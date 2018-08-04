defmodule CouponMarketplace.Utils.NewIO do
  @moduledoc """
  NewIO is a module meant to help get user input
  in various formats.
  """

  def gets_credentials(prompt) do
    IO.gets(prompt)
    |> String.trim()
  end

  def gets_title(prompt) do
    IO.gets(prompt)
    |> String.trim()
    |> String.capitalize()
  end

  def gets(prompt) do
    IO.gets(prompt)
    |> String.trim()
    |> String.downcase()
  end

  def press_enter do
    IO.gets("press enter")
  end
end