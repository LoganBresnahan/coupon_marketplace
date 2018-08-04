defmodule CouponMarketplace.Screens.Register do
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Utils.NewIO
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Repo

  @moduledoc """
  The Register Screen allows a user to register.
  When successful it takes them to the Login screen.

  I have decided to hash the passwords with Bcrypt.
  Bcrypt is well tested and the package bcrypt_elixir
  is simple to use.
  """

  def present do
    IO.puts """

    ~~~~~~~~~~ Registration ~~~~~~~~~~
    """

    IO.puts "Please enter a username"
    username = NewIO.gets_credentials "> "

    IO.puts "Please enter a password"
    password = NewIO.gets_credentials "> "
    
    hash_password = Bcrypt.hash_pwd_salt(password)
    deposit = accept_and_verify_deposit()

    Task.async(fn -> user_creation(username, hash_password, deposit) end)
    |> Task.await()
    |> handle_registration()
  end

  defp accept_and_verify_deposit do
    IO.puts "Please enter a $20.00 deposit"

    deposit = NewIO.gets "> "

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

    IO.puts "$$$$$$$$$$ Registered! $$$$$$$$$$"

    NewIO.press_enter
  end
  defp handle_registration({:error, changeset}) do
    Instructions.help(:register, changeset)

    input = NewIO.gets("> ")

    case input do
      "r" ->
        present()
      "l" ->
        StateTree.write(%{screen: :login})
      "e" ->
        System.stop()
      _ ->
        IO.puts "Input not supported."

        NewIO.press_enter
    end
  end
end