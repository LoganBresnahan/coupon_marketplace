defmodule CouponMarketplace.Interface.StateTree do
  use GenServer
  alias CouponMarketplace.Interface.Router

  #Client API
  def start_link([state_tree]) do
    GenServer.start_link(__MODULE__, state_tree, name: __MODULE__)
  end

  def write(new_state_tree) do
    GenServer.call(__MODULE__, {:write, new_state_tree})
  end

  def read do
    GenServer.call(__MODULE__, :read)
  end

  #CallBacks
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