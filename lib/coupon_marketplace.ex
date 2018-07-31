defmodule CouponMarketplace do
  use Application
  alias CouponMarketplace.Repo
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Interface.Router

  @moduledoc """
    CouponMarketplace is an application that gives its users
    a place to buy and sell coupons from one another.
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
