defmodule CouponMarketplace.Utils.NewIO do
  @callback gets(String.t) :: String.t

  def gets(prompt) do
    IO.gets(prompt)
  end
end