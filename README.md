# Elixir Queue Lib (Qlib)

A simple queue abstraction library to support leasing and buffering for Elixir.
QLib provides two main queue abstractions LeasedQueue and BufferedQueue.

## LeasedQueue

LeasedQueue is a simple and leased abstraction around state.

The items stored in a LeasedQueue have a limited lifetime. The LeasedQueue sets a
period time or lease time (by default 60 seconds) which is used to automatically
remove expired items.

An item expires if its time (processing time) in the queue is greater than the leased
time specified by the queue. The processing time is the time when the item was
stored in the queue.

A LeasedQueue guarantees that a pop-call never will return an expired item.

Example:
```elixir
{:ok, q} = LeasedQueue.new
LeasedQueue.push(q, 1)
LeasedQueue.pop(q)      
LeasedQueue.size(q)
LeasedQueue.clear(q)
LeasedQueue.destroy(q)
```
## BufferedQueue

BufferedQueue is a simple and buffered abstraction around state.

A BufferedQueue can only store a N maximum of items. The size of BufferedQueue
will never exceed the N items. If a BufferedQueue achieve its maximum capacity
and a new item has to be inserted, the collection automatically will remove its
oldest item.

The default capacity of BufferedQueue is 1000 items. The developers can set the
capacity value during the creation of the collection.

Example:
```elixir
{:ok, q} = BufferedQueue.new 5000
BufferedQueue.push(q, 1)
BufferedQueue.pop(q)
BufferedQueue.size(q)
BufferedQueue.clear(q)
BufferedQueue.destroy(q)
```
## Installation

If [available in Hex](https://hex.pm/packages/elixir_qlib), the package can be installed as:

  1. Add `elixir_qlib` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:elixir_qlib, "~> 0.1.0"}]
    end
    ```

  2. Ensure `elixir_qlib` is started before your application:

    ```elixir
    def application do
      [applications: [:elixir_qlib]]
    end
    ```
