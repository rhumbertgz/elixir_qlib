defmodule QLib.BufferedServer do
  @moduledoc false
  use GenServer

  def init(capacity) do
    {:ok, {[], 0, capacity}}
  end

  def handle_call(:pop, _from, {[], buffer, capacity}) do
    {:reply, nil, {[], buffer, capacity}}
  end

  def handle_call(:pop, _from, {[{_t, value} | rest], buffer, capacity}) do
    {:reply, value, {rest, (buffer - 1), capacity}}
  end

  def handle_call(:size, _from, {items, buffer, capacity}) do
    {:reply, length(items), {items, buffer, capacity}}
  end

  def handle_call(:destroy, _from, _state) do
    {:reply, :ok, nil}
  end

  def handle_call(request, from, state) do
    # Call the default implementation from GenServer
    super(request, from, state)
  end

  def handle_cast({:push, item}, {items, buffer, capacity}) when buffer < capacity do
    items = items ++ [{:erlang.system_time, item}]
    {:noreply, {items, (buffer + 1), capacity}}
  end

  def handle_cast({:push, item}, {[_oldItem | rest], buffer, capacity}) do
    items = rest ++ [{:erlang.system_time, item}]
    {:noreply, {items, buffer , capacity}}
  end

  def handle_cast(:clear, {_, _, capacity}) do
     {:noreply, {[], 0, capacity}}
  end

  def handle_cast(request, state) do
    super(request, state)
  end

  # Catching unhanded messages
  def handle_info(_, state) do
    {:ok, state}
  end

end
