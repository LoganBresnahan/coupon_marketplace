defmodule CouponMarketplace do
  use Application
  alias CouponMarketplace.Repo

  @moduledoc """
    CouponMarketplace is an application that gives its users
    a place to buy and sell coupons from one another.
  """

  def start(_type, _args) do
    children = [
      {Repo, []}
    ]

    opts = [strategy: :one_for_one, name: CouponMarketplace.Application]
    Supervisor.start_link(children, opts)
  end
end
