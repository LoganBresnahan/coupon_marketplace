defmodule CouponMarketplace.Screens.NewSession do
  alias CouponMarketplace.Interface.StateTree

  @moduledoc """
  The New Session Screen is the first thing a user
  sees when starting the application.
  """

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
        IO.puts "Input not supported."

        @io.press_enter
    end
  end
end