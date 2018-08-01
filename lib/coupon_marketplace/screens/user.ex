defmodule CouponMarketplace.Screens.User do
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Interface.StateTree

  @io Application.get_env(:coupon_marketplace, :io)

  def present do
    user_data = StateTree.read().user_data

    IO.puts """
    *User Profile*

    Username: #{user_data.username}
    Balance: #{user_data.balance}
    """
    Instructions.help(:user)

    input = @io.gets("> ")

    case input do
      _ -> Instructions.help(:user)
    end
  end
end