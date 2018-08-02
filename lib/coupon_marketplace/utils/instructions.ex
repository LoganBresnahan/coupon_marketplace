defmodule CouponMarketplace.Utils.Instructions do
  def help(state, data \\ nil) do
    case state do
      :new_session ->
        new_session()
      :login ->
        login()
      :register ->
        register(data)
      :user ->
        user()
      :deposit ->
        deposit(data)
    end
  end

  defp new_session do
    IO.puts """

    Available Options:
    "r" for register
    "l" for login
    "a" for admin
    "e" for exit
    """
  end

  defp login do
    IO.puts """

    What would you like to do?
    "l" for login
    "r" for register
    "e" for exit
    """
  end

  defp register(data) do
    IO.puts """
    
    *** Error attempting to register. ***
    #{readable_changeset_errors(data)}

    What would you like to do?
    "r" for register
    "l" for login
    "e" for exit
    """
  end

  defp user do
    IO.puts """

    What would you like to do?
    "p" for post a coupon for sale
    "r" for request a coupon
    "d" for deposit more money
    """
  end

  defp deposit(data) do
    IO.puts """

    *** Error updating your balance ***
    #{readable_changeset_errors(data)}

    What would you like to do?
    "t" for try again
    "lo" for logout
    "e" for exit
    "p" for your profile page
    """
  end

  defp readable_changeset_errors(changeset) do
    changeset.errors
    |> Enum.reduce("", fn({attribute, {message, _}}, acc) -> 
      Atom.to_string(attribute) <> " #{message}\n" <> acc
    end)
  end
end