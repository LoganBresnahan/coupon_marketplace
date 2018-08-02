defmodule CouponMarketplace.Utils.Instructions do
  def help(:new_session) do
    IO.puts """

    Available Options:
    "r" for register
    "l" for login
    "a" for admin
    "e" for exit
    """
  end
  def help(:login) do
    IO.puts """

    What would you like to do?
    "l" for login
    "r" for register
    "e" for exit
    """
  end
  def help(:user) do
    IO.puts """

    What would you like to do?
    "a" add a new coupon
    "p" for post a coupon for sale
    "r" for request a coupon
    "d" for deposit more money
    "lo" for logout
    """
  end

  def help(:register, data) do
    IO.puts """
    
    *** Error attempting to register. ***
    #{readable_changeset_errors(data)}

    What would you like to do?
    "r" for register
    "l" for login
    "e" for exit
    """
  end
  def help(:deposit, data) do
    IO.puts """

    *** Error updating your balance ***
    #{readable_changeset_errors(data)}

    What would you like to do?
    "t" for try again
    "lo" for logout
    "p" for your profile page
    """
  end
  def help(:coupon, data) do
    IO.puts """

    *** Error creating coupon ***
    #{readable_changeset_errors(data)}

    What would you like to do?
    "lo" for logout
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