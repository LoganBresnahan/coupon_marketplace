defmodule CouponMarketplace.Interface.Router do
  use Supervisor
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Screens.NewSession
  alias CouponMarketplace.Screens.Register
  alias CouponMarketplace.Screens.Login
  alias CouponMarketplace.Screens.Admin

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    StateTree.read()
    |> operate()

    Supervisor.init([], [strategy: :one_for_one])
  end

  def operate(%{screen: :new_session}) do
    NewSession.present()

    StateTree.read()
    |> operate()
  end

  def operate(%{screen: :register}) do
    Register.present()

    StateTree.read()
    |> operate()
  end

  def operate(%{screen: :login}) do
    Login.present()

    StateTree.read()
    |> operate()
  end

  def operate(%{screen: :admin}) do
    Admin.present()

    StateTree.read()
    |> operate()
  end
end