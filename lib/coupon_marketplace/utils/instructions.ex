defmodule CouponMarketplace.Utils.Instructions do
  @moduledoc """
  A module that helps display instructions when something
  goes wrong in a Screen. This is a good place to handle
  ecto changeset errors that need formatting.
  """

  def help(:register, data) do
    IO.puts """
    
    ********** Error attempting to register. **********
    #{readable_changeset_errors(data)}

    What would you like to do?
    "r" register
    "l" login
    "e" exit
    """
  end
  def help(:deposit, data) do
    IO.puts """

    ********** Error updating your balance **********
    #{readable_changeset_errors(data)}

    What would you like to do?
    "t" try again
    "lo" logout
    "u" your profile page
    """
  end
  def help(:coupon, data) do
    IO.puts """

    ********** Error creating coupon **********
    #{readable_changeset_errors(data)}

    What would you like to do?
    "lo" logout
    "u" your profile page
    """
  end

  defp readable_changeset_errors(changeset) do
    changeset.errors
    |> Enum.reduce("", fn({attribute, {message, _}}, acc) -> 
      Atom.to_string(attribute) <> " #{message}\n" <> acc
    end)
  end
end