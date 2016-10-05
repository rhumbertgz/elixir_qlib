defmodule QLib.LeasedQueue do
  @moduledoc """
  LeasedQueue is a simple and leased abstraction around state.

  The items stored in a LeasedQueue have a limited lifetime. The LeasedQueue sets a
  period time or lease time (by default 60 seconds) wich is used to automatically
  remove expired items.

  An item expires if its time (procesing time) in the queue is greater than the leased
  time setted in the queue. The procesing time is represents the time when the item was
  stored in the queue.

  A LeasedQueue guarantees that a pop-call never will return an expired item.

  ## Examples
  {:ok, q} = LeasedQueue.new
  LeasedQueue.push(q, 1)
  LeasedQueue.pop(q)
  LeasedQueue.size(q)
  LeasedQueue.clear(q)
  LeasedQueue.destroy(q)

  """

  @doc """
  Creates a new empty LeasedQueue using the `lease` value as lease time.

  """
  def new(lease \\ 10_000) do
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
