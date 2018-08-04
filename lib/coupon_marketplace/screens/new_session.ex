defmodule CouponMarketplace.Screens.NewSession do
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Utils.NewIO

  @moduledoc """
  The New Session Screen is the first thing a user
  sees when starting the application.
  """

  def present do
    IO.puts("""

    Welcome to the Coupon Marketplace

    Available Options:
    "r" register
    "l" login
    "e" exit
    """)

    input = NewIO.gets("> ")

    input
    |> case do
      "r" ->
        StateTree.write(%{screen: :register})

      "l" ->
        StateTree.write(%{screen: :login})

      "e" ->
        System.stop()

      _ ->
        IO.puts("Input not supported.")

        NewIO.press_enter()
    end
  end
end
