defmodule CouponMarketplace.Screens.User do
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Interface.StateTree

  @io Application.get_env(:coupon_marketplace, :io)

  def present(current_state) do
    IO.puts """
    *User Profile*

    Username: #{current_state.user_data.username}
    Balance: #{current_state.user_data.balance}
    """
    Instructions.help(:user)

    input = @io.gets("> ")

    case input do
      # "p" ->
      #   #all your coupons screen?
      # "r" ->
      #   #all coupons?
      "d" ->
        %{current_state | screen: :deposit}
        |> StateTree.write()
      _ -> 
        Instructions.help(:user)
    end
  end
end