defmodule CouponMarketplace.Interface.StateTree do
  use GenServer

  @moduledoc """
  The StateTree uses Genserver as an easy way to
  handle storing the current "state" of a user's
  interaction with the application. Its purpose is
  to simply return the state when requested and update
  the state when things change during the flow of
  the application. We only use the handle_call/3 callback
  as it is important for the state to be updated synchronously
  before the user would need to interact with the new state.

  We use this StateTree to remember what screen we are on
  and details about a user's session.
  """

  # Client API
  def start_link([state_tree]) do
    GenServer.start_link(__MODULE__, state_tree, name: __MODULE__)
  end

  def write(new_state_tree) do
    GenServer.call(__MODULE__, {:write, new_state_tree})
  end

  def read do
    GenServer.call(__MODULE__, :read)
  end

  # CallBacks
  @impl true
  def init(state_tree) do
    {:ok, state_tree}
  end

  @impl true
  def handle_call({:write, new_state_tree}, _from, _state_tree) do
    {:reply, new_state_tree, new_state_tree}
  end

  def handle_call(:read, _from, state_tree) do
    {:reply, state_tree, state_tree}
  end
end
