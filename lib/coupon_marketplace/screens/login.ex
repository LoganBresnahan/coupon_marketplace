defmodule CouponMarketplace.Screens.Login do
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Repo

  @io Application.get_env(:coupon_marketplace, :io)

  def present do
    IO.puts """

    *Login*
    """
    
    username = @io.gets "User Name > "

    password = @io.gets "Password > "

    look_up_user(username, password)
  end

  defp look_up_user(username, password) do
    Repo.get_by(User, username: username)
    |> case do
      nil ->
        handle_login_failure("Failed to Find username")
      schema ->
        verify_password(username, password, schema)
    end
  end

  defp verify_password(username, password, schema) do
    Bcrypt.verify_pass(password, schema.password)
    |> case do
      true -> 
        update_state_tree(username, schema)
      false ->
        handle_login_failure("Incorrect Password")
    end
  end

  defp update_state_tree(username, schema) do
    StateTree.write(
      %{
        screen: :user,
        user_data: %{username: username, balance: schema.balance}
      }
    )
  end

  defp handle_login_failure(message) do
    IO.puts "*** #{message} ***"
    Instructions.help(:login)

    input = @io.gets("> ")
    
    case input do
      "r" ->
        StateTree.write(%{screen: :register})
      "e" -> 
        System.stop()
      _ ->
       present()
    end
  end
end