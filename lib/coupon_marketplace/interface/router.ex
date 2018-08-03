defmodule CouponMarketplace.Interface.Router do
  use Supervisor
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Screens.NewSession
  alias CouponMarketplace.Screens.Register
  alias CouponMarketplace.Screens.Login
  alias CouponMarketplace.Screens.Admin
  alias CouponMarketplace.Screens.User
  alias CouponMarketplace.Screens.Deposit
  alias CouponMarketplace.Screens.Marketplace

  @moduledoc """
  This module is the Router for deciding which "screen" to show
  the user.

  The router is a Supervised process that reads from the StateTree
  Genserver and passes the current state to the appropriate
  screen module. The corresponding module that gets called handles the
  writing to the StateTree Genserver. Based on the incoming state
  from the module we pattern match to call the correct operate/1 function.

  There are many ways from within the Screen modules to handle their return
  values so we wouldn't need to call StateTree.read/0 before the
  operate/1 function, but I think I enjoy this pattern as it makes the
  Router responsible for giving a "state" to the operate/1 function and
  we don't have to worry about every possible endcase for the modules.
  """

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

  defp operate(%{screen: :user, user: %{type: "admin"}}) do
    StateTree.read()
    |> Admin.present()

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

  defp operate(%{screen: :marketplace}) do
    StateTree.read()
    |> Marketplace.present()

    StateTree.read()
    |> operate()
  end
end 