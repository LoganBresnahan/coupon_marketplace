defmodule CouponMarketplace.Screens.NewSession do
  alias CouponMarketplace.Interface.StateTree

  @io Application.get_env(:coupon_marketplace, :io)

  def present do
    IO.puts """

    Welcome to the Coupon Marketplace
    
    Available Options:
    "r" register
    "l" login
    "e" exit
    """

    input = @io.gets "> "

    input
    |> case do
      "r" ->
        StateTree.write(%{screen: :register})
      "l" ->
        StateTree.write(%{screen: :login})
      "e" ->
        System.stop()
      _ ->
        present()
    end
  end
end