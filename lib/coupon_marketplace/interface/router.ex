defmodule CouponMarketplace.Interface.Router do
  use Supervisor
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Screens.NewSession
  alias CouponMarketplace.Screens.Register
  alias CouponMarketplace.Screens.Login
  alias CouponMarketplace.Screens.Admin
  alias CouponMarketplace.Screens.User
  alias CouponMarketplace.Screens.Deposit

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    StateTree.read()
    |> operate()

    Supervisor.init([], [strategy: :one_for_one])
  end

  defp operate(%{screen: :new_session}) do
    NewSession.present()

    StateTree.read()
    |> operate()
  end

  defp operate(%{screen: :register}) do
    Register.present()

    StateTree.read()
    |> operate()
  end

  defp operate(%{screen: :login}) do
    Login.present()

    StateTree.read()
    |> operate()
  end

  defp operate(%{screen: :admin}) do
    Admin.present()

    StateTree.read()
    |> operate()
  end

  defp operate(%{screen: :user}) do
    StateTree.read()
    |> User.present()

    StateTree.read()
    |> operate()
  end

  defp operate(%{screen: :deposit}) do
    StateTree.read()
    |> Deposit.present()

    StateTree.read()
    |> operate()
  end
end 