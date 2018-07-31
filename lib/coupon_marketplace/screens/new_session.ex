defmodule CouponMarketplace.Screens.NewSession do
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Utils.NewIO
  alias CouponMarketplace.Interface.StateTree

  @io Application.get_env(:coupon_marketplace, :io)

  def present do
    IO.puts """

    Welcome to the Coupon Marketplace
    Type "h" for help to show a list of options.
    """

    input = @io.gets "> "

    input
    |> String.trim_trailing()
    |> String.downcase()
    |> case do
      "r" ->
        StateTree.write(%{screen: :register})
      "l" ->
        StateTree.write(%{screen: :login})
      "a" ->
        StateTree.write(%{screen: :admin})
      "h" ->
        Instructions.help(:new_session)
      "e" ->
        System.stop(0)
      _ ->
        Instructions.help(:new_session)
    end
  end
end