# CouponMarketplace

## Dependencies
1. Elixir ~> 1.6
2. Postgres 9 or greater.

## How to Run
1. Clone this repository to your computer.

2. `cd coupon_marketplace`

3. `mix deps.get`

4. Configure your development database. The config can be found at:
/coupon_marketplace/config/dev.exs

By default it looks like this,
```
config :coupon_marketplace, CouponMarketplace.Repo,
  database: "coupon_marketplace_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
```
You will need to edit the username and password sections
only if "postgres" isn't your development defaults.

5. `mix ecto.setup`

6. `mix run`

## Other Tips
1. Explanations for the code can be found in each
individual file inside a @moduledoc.
An explanation for postgres can be found at:
/coupon_marketplace/lib/coupon_marketplace/repo.ex

2. After running `mix setup` the development
database should be populated with records.
These are basic users and one admin user with
usernames and passwords. (but you can also create your 
own records through the interface)

*The admin is special. You can only generate Marketplace
reports when logged in as an admin.*
- The admin username is: admin
- The password is: admin

The seed file can be found at:
/coupon_marketplace/lib/coupon_marketplace/mix/tasks/seed.ex

3. To re-seed the database run `mix ecto.reset`
