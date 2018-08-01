defmodule CouponMarketplace.Screens.NewSession do
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Interface.StateTree

  @io Application.get_env(:coupon_marketplace, :io)

  def present do
    IO.puts """

    Welcome to the Coupon Marketplace
    Type "h" for help to show a list of options.
    """

    input = @io.gets "> "

    input
    |> case do
      "r" ->
        StateTree.write(%{screen: :register})
      "l" ->
        StateTree.write(%{screen: :login})
      "a" ->
        StateTree.write(%{screen: :admin})
      "e" ->
        System.stop()
      _ ->
        Instructions.help(:new_session)
    end
  end
end