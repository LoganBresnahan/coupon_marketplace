defmodule CouponMarketplace.Repo do
  use Ecto.Repo,
    otp_app: :coupon_marketplace,
    adapter: Ecto.Adapters.Postgres

  @moduledoc """
  The Case for Postgres and Ecto

  I think that postgres is still the best option for storing permanent data.
  Thanks to Ecto and Postgrex we have a mature system that we know will
  be continued to be supported by the core Elixir team. Ecto is also very
  developer friendly. It is easy to understand and does a really good
  job at organizing how we associate and use our data. There are
  other options, and one that I seriously thought about was Mnesia. Mnesia seemed like
  a nice choice that allowed me to stay within "OTP land", and it does
  sound tempting to do away with external dependecies like a separately
  hosted database. All in all, I think when using Elixir it is still easier 
  to go with the tried and true postgres relational database.
  """
end