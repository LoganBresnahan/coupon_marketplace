defmodule CouponMarketplace do
  use Application
  alias CouponMarketplace.Repo
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Interface.Router

  @moduledoc """
    CouponMarketplace is an application that gives its users
    a place to buy and sell coupons from one another.

    This module uses the Application module so our app can be loaded 
    and started by the runtime. It starts a supervision tree that includes
    our Repo, StateTree, and Router.
  """

  def start(_type, _args) do
    children = [
      {Repo, []},
      {StateTree, [%{screen: :new_session}]},
      {Router, []}
    ]

    opts = [strategy: :one_for_one, name: CouponMarketplace.Application]
    Supervisor.start_link(children, opts)
  end
end
