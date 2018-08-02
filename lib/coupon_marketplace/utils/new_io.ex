defmodule CouponMarketplace.Utils.NewIO do
  @callback gets(String.t) :: String.t

  def gets(prompt) do
    IO.gets(prompt)
    |> String.trim_trailing()
    |> String.downcase()
  end
end