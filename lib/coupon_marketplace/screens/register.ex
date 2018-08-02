defmodule CouponMarketplace.Screens.Register do
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Repo

  @io Application.get_env(:coupon_marketplace, :io)

  def present do
    IO.puts """

    *Registration*
    """

    IO.puts "Please enter a username"
    username = @io.gets "> "

    IO.puts "Please enter a password" 
    password = @io.gets "> "
    hash_password = Bcrypt.hash_pwd_salt(password)
    deposit = accept_and_verify_deposit()

    Task.async(fn -> user_creation(username, hash_password, deposit) end)
    |> Task.await()
    |> handle_registration()
  end

  defp accept_and_verify_deposit do
    IO.puts "Please enter a $20.00 deposit"

    deposit = @io.gets "> "

    case deposit do
      "20.00" ->
        Decimal.new(deposit)
      _ ->
        accept_and_verify_deposit()
    end
  end

  defp user_creation(username, password, deposit) do
    User.changeset(
      %User{},
      %{
        username: username,
        password: password,
        balance: deposit
      }
    ) |> Repo.insert()
  end

  defp handle_registration({:ok, _}) do
    StateTree.write(%{screen: :login})
  end
  defp handle_registration({:error, changeset}) do
    Instructions.help(:register, changeset)

    input = @io.gets("> ")

    case input do
      "l" ->
        StateTree.write(%{screen: :login})
      "e" ->
        System.stop()
      _ ->
        present()
    end
  end
end