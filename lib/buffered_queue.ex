defmodule QLib.BufferedQueue do
  @moduledoc """
  BufferedQueue is a simple and buffered abstraction around state.

  A BufferedQueue can only store a N maximum of items. The size of BufferedQueue
  will never exceed the N items. If a BufferedQueue achieve its maximum capacity
  and a new item has to be inserted, the collection automatically will remove its
  oldest item.

  The default capacity of BufferedQueue is 1000 items. The developers can set the
  capacity value during the creation of the collection.

  ## Examples
  {:ok, q} = BufferedQueue.new 5000
  BufferedQueue.push(q, 1)
  BufferedQueue.pop(q)
  BufferedQueue.size(q)
  BufferedQueue.clear(q)
  BufferedQueue.destroy(q)

  """

  @doc """
  Creates a new empty BufferedQueue with a maximum of `capacity` items.

  """
  def new(capacity \\ 1000) do
    GenServer.start_link(QLib.BufferedServer, capacity)
  end

  @doc """
  Destroy the BufferedQueue.

  """
  def destroy(qid) do
    GenServer.stop(qid)
  end

  @doc """
  Inserts the `item` in the BufferedQueue.

  """
  def push(queue, item) do
    GenServer.cast(queue, {:push, item})
  end

  @doc """
  Removes and returns the first item in the BufferedQueue.

  """
  def pop(queue, timeout \\ 5000) do
    GenServer.call(queue, :pop, timeout)
  end

  @doc """
  Removes all the items in the BufferedQueue.

  """
  def clear(queue) do
    GenServer.cast(queue, :clear)
  end

  @doc """
  Returns the size of the BufferedQueue.

  """
  def size(queue, timeout \\ 5000) do
    GenServer.call(queue, :size, timeout)
  end

end
