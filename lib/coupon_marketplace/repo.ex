defmodule CouponMarketplace.Repo do
  use Ecto.Repo,
    otp_app: :coupon_marketplace,
    adapter: Ecto.Adapters.Postgres
end