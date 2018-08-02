defmodule CouponMarketplace.Screens.Marketplace do
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.Coupon
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Repo

  @io Application.get_env(:coupon_marketplace, :io)

  def present(current_state) do
    IO.puts """

    *The Marketplace*
    """
  end
end