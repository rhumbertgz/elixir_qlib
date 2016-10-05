defmodule QLib.LeasedServer do
  @moduledoc false
  use GenServer

    def init(lease) do
      nlease = :erlang.convert_time_unit(lease, :millisecond, :native)
      {:ok, {[], lease, nlease, 0}}
    end

    def handle_call(:pop, _from, {[], lease, nlease, 0}) do
      {:reply, nil, {[], lease, nlease, 0}}
    end

    def handle_call(:pop, _from, {items, lease, nlease, timerRef}) do
      {value, rest} = valid_item?(items, nlease)
      timerRef =
        case rest do
          [] -> Process.cancel_timer(timerRef)
                0
           _ -> timerRef
        end

      {:reply, value, {rest, lease, nlease, timerRef}}
    end

    def handle_call(:size, _from, {items, lease, nlease, timerRef}) do
      {:reply, length(items), {items, lease, nlease, timerRef}}
    end

    def handle_call(:destroy, _from, _state) do
      {:reply, :ok, nil}
    end

    def handle_call(request, from, state) do
      # Call the default implementation from GenServer
      super(request, from, state)
    end

    def handle_cast({:push, item}, {items, lease, nlease, 0}) do
      timerRef = timer_ref(lease)
      items = items ++ [{:erlang.system_time, item}]
      {:noreply, {items, lease, nlease, timerRef}}
    end

    def handle_cast({:push, item}, {items, lease, nlease, timerRef}) do
      items = items ++ [{:erlang.system_time, item}]
      {:noreply, {items, lease, nlease, timerRef}}
    end

    def handle_cast(:clear, {_, lease, nlease, 0}) do
       {:noreply, {[], lease, nlease, 0}}
    end

    def handle_cast(:clear, {_, lease, nlease, timerRef}) do
       Process.cancel_timer(timerRef)
       {:noreply, {[], lease, nlease, 0}}
    end

    def handle_cast(request, state) do
      super(request, state)
    end

    def handle_info(:lease, {items, lease, nlease, _}) do
      time = :erlang.system_time
      {_expired, items} = Enum.split_while(items, fn {k, _v} -> (time - k) > nlease end)
      # Start the timer again if there is active items
      timerRef = timer_ref(items, lease)
      {:noreply, {items, lease, nlease, timerRef}}
    end

    # Catching unhanded messages
    def handle_info(_, state) do
      {:ok, state}
    end

    defp timer_ref(lease) do
      Process.send_after(self(), :lease , lease)
    end

    defp timer_ref([], _lease) do
      0
    end

    defp timer_ref(_items, lease) do
      timer_ref(lease)
    end

    defp valid_item?([], _nlease) do
      {nil, []}
    end

    defp valid_item?([{time, value}| t], nlease) do
      now = :erlang.system_time
      cond do
        ((now - time) > nlease) -> valid_item?(t, nlease)
        true -> {value , t}
      end
    end

end
