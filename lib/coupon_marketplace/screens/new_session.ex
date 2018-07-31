defmodule CouponMarketplace.Screens.NewSession do
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Interface.StateTree

  def present do
    IO.puts """

    Welcome to the Coupon Marketplace
    Type "h" for help to show a list of options.
    """

    input = IO.gets "> "
    IO.puts "******"
    IO.puts input
    IO.puts "&&&&&&"
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