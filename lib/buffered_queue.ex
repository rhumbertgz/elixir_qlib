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
  
      iex(1)> {:ok, q} = QLib.BufferedQueue.new 3
      {:ok, #PID<0.140.0>}
      iex(2)> QLib.BufferedQueue.push(q, 1)
      :ok
      iex(3)> QLib.BufferedQueue.push(q, 2)
      :ok
      iex(4)> QLib.BufferedQueue.push(q, 3)
      :ok
      iex(5)> QLib.BufferedQueue.push(q, 4)
      :ok
      iex(6)> QLib.BufferedQueue.size(q)
      3
      iex(7)> QLib.BufferedQueue.pop(q)
      2
      iex(8)> QLib.BufferedQueue.size(q)
      2
      iex(9)> QLib.BufferedQueue.clear(q)
      :ok
      iex(10)> QLib.BufferedQueue.size(q)
      0
      iex(11)> QLib.BufferedQueue.destroy(q)
      :ok

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
