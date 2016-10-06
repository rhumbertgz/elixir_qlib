defmodule QLib.LeasedQueue do
  @moduledoc """
  LeasedQueue is a simple and leased abstraction around state.

  The items stored in a LeasedQueue have a limited lifetime. The LeasedQueue sets a
  period time or lease time (by default 60 seconds) which is used to automatically
  remove expired items.

  An item expires if its time (processing time) in the queue is greater than the leased
  time specified by the queue. The processing time is the time when the item was
  stored in the queue.

  A LeasedQueue guarantees that a pop-call never will return an expired item.

  ## Examples
      iex(1)> {:ok, q} = QLib.LeasedQueue.new 5_000
      {:ok, #PID<0.152.0>}
      iex(2)> QLib.LeasedQueue.push(q, 1)
      :ok
      iex(3)> :timer.sleep(1_000)
      :ok
      iex(4)> QLib.LeasedQueue.push(q, 2)
      :ok
      iex(5)> :timer.sleep(4_000)
      nil
      iex(6)> QLib.LeasedQueue.size(q)
      0
      iex(7)> QLib.LeasedQueue.push q, 3
      :ok
      iex(8)> QLib.LeasedQueue.push q, 4
      :ok
      iex(9)> QLib.LeasedQueue.size(q)
      1
      iex(10)> QLib.LeasedQueue.size(q)
      0
      iex(11)> QLib.LeasedQueue.destroy(q)
      :ok

  """

  @doc """
  Creates a new empty LeasedQueue using the `lease` value as lease time.

  """
  def new(lease \\ 60_000) do
    GenServer.start_link(QLib.LeasedServer, lease)
  end

  @doc """
  Destroy the LeasedQueue.

  """
  def destroy(queue) do
    GenServer.stop(queue)
  end

  @doc """
  Inserts the `item` in the LeasedQueue.

  """
  def push(queue, item) do
    GenServer.cast(queue, {:push, item})
  end

  @doc """
  Removes and return the first item in the LeasedQueue.

  """
  def pop(queue, timeout \\ 5000) do
    GenServer.call(queue, :pop, timeout)
  end

  @doc """
  Removes all the items in the LeasedQueue.

  """
  def clear(queue) do
    GenServer.cast(queue, :clear)
  end

  @doc """
  Returns the size of the LeasedQueue.

  """
  def size(queue, timeout \\ 5000) do
    GenServer.call(queue, :size, timeout)
  end

end
