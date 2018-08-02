defmodule CouponMarketplace.Utils.NewIO do
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