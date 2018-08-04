defmodule CouponMarketplace.Screens.Login do
  alias CouponMarketplace.Utils.NewIO
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Repo

  @moduledoc """
  The Login Screen is where a user logs in. On success,
  we update the StateTree with some of the user's information.
  """

  def present do
    IO.puts """

    ~~~~~~~~~~ Login ~~~~~~~~~~
    """
    
    username = NewIO.gets_credentials "User Name > "

    password = NewIO.gets_credentials "Password > "

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
        user: %{
          id: schema.id, 
          username: username, 
          balance: schema.balance,
          type: schema.type
        }
      }
    )
  end

  defp handle_login_failure(message) do
    IO.puts """

    ********** #{message} **********

    What would you like to do?
    "l" login
    "r" register
    "e" exit
    """

    input = NewIO.gets("> ")
    
    case input do
      "l" ->
        present()
      "r" ->
        StateTree.write(%{screen: :register})
      "e" -> 
        System.stop()
      _ ->
        IO.puts "Input not supported."

        NewIO.press_enter
    end
  end
end