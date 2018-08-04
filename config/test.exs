use Mix.Config

config :coupon_marketplace, CouponMarketplace.Repo,
  database: "coupon_marketplace_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox