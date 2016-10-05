defmodule ElixirQlibTest do
  use ExUnit.Case

  doctest QLib.LeasedQueue
  doctest QLib.BufferedQueue


  test "buffered queue" do
    {:ok, q} = QLib.BufferedQueue.new 3
    QLib.BufferedQueue.push q, 1
    QLib.BufferedQueue.push q, 2
    QLib.BufferedQueue.push q, 3
    QLib.BufferedQueue.push q, 4
    QLib.BufferedQueue.push q, 5

    assert QLib.BufferedQueue.pop(q) == 3
    assert QLib.BufferedQueue.pop(q) == 4
    assert QLib.BufferedQueue.size(q) == 1

    QLib.BufferedQueue.clear(q)

    assert QLib.BufferedQueue.size(q) == 0

    QLib.BufferedQueue.destroy q
  end



  test "leased queue" do

    {:ok, q} = QLib.LeasedQueue.new 5_000
    QLib.LeasedQueue.push q, 1
    :timer.sleep(1_000)
    QLib.LeasedQueue.push q, 2

    assert QLib.LeasedQueue.pop(q) == 1
    :timer.sleep(1_000)
    assert QLib.LeasedQueue.size(q) == 1

    :timer.sleep(4_000)
    assert QLib.LeasedQueue.pop(q) == nil

    QLib.LeasedQueue.push q, 3
    QLib.LeasedQueue.push q, 4
    assert QLib.LeasedQueue.size(q) == 2

    QLib.LeasedQueue.clear(q)
    assert QLib.LeasedQueue.size(q) == 0

    QLib.LeasedQueue.destroy q
  end
end
