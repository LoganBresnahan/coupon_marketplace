use Mix.Config

config :coupon_marketplace, CouponMarketplace.Repo,
  database: "coupon_marketplace_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"