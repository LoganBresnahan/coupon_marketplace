defmodule CouponMarketplace.Utils.NewIO do
  @moduledoc """
  NewIO is a module meant to help get user input
  in various formats but also a module that makes
  it easier to test IO input. 

  We have to define a @callback behaviour to get
  our functions working with Mox. More can
  be found in the Mox documentation, but this is
  also the reason you see the line:
  @io Application.get_env(:coupon_marketplace, :io)
  in the modules that use these functions.

  Mox: https://hexdocs.pm/mox/Mox.html
  """

  @callback gets_credentials(String.t) :: String.t
  @callback gets_title(String.t) :: String.t
  @callback gets(String.t) :: String.t

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
end