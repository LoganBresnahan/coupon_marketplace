defmodule Mix.Tasks.Seed do
  use Mix.Task
  alias CouponMarketplace.Repo
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Models.Brand
  alias CouponMarketplace.Models.Coupon

  def run(_) do
    Repo.start_link([])

    user_one = User.changeset(
      %User{},
      %{
        username: "Nausicaa",
        password: Bcrypt.hash_pwd_salt("wind"),
        balance: Decimal.new(20.00)
      }
    ) |> Repo.insert!()

    user_two = User.changeset(
      %User{},
      %{
        username: "Ponyo",
        password: Bcrypt.hash_pwd_salt("sea"),
        balance: Decimal.new(40.70)
      }
    ) |> Repo.insert!()

    user_three = User.changeset(
      %User{},
      %{
        username: "Mononoke",
        password: Bcrypt.hash_pwd_salt("wolf"),
        balance: Decimal.new(5.25)
      }
    ) |> Repo.insert!()

    brand_one = Brand.changeset(
      %Brand{},
      %{name: "Mamma Aiuto!"}
    ) |> Repo.insert!()

    brand_two = Brand.changeset(
      %Brand{},
      %{name: "Cat Bus"}
    ) |> Repo.insert!()

    Coupon.changeset(
      %Coupon{},
      %{
        title: "Mamma Aiuto! Summer Discount",
        value: Decimal.new(4.50),
        status: :available,
        user_id: user_one.id,
        brand_id: brand_one.id
      }
    ) |> Repo.insert!()

    Coupon.changeset(
      %Coupon{},
      %{
        title: "Mamma Aiuto! New Discount",
        value: Decimal.new(6.75),
        status: :available,
        user_id: user_one.id,
        brand_id: brand_one.id
      }
    ) |> Repo.insert!()

    Coupon.changeset(
      %Coupon{},
      %{
        title: "Cat Bus. Free Ride",
        value: Decimal.new(5.00),
        status: :available,
        user_id: user_two.id,
        brand_id: brand_two.id
      }
    ) |> Repo.insert!()

    Coupon.changeset(
      %Coupon{},
      %{
        title: "Cat Bus. Discount Ride",
        value: Decimal.new(2.50),
        status: :available,
        user_id: user_two.id,
        brand_id: brand_two.id
      }
    ) |> Repo.insert!()

    Coupon.changeset(
      %Coupon{},
      %{
        title: "Cat Bus. Weekend Ride",
        value: Decimal.new(1.25),
        status: :available,
        user_id: user_three.id,
        brand_id: brand_two.id
      }
    ) |> Repo.insert!()

    Coupon.changeset(
      %Coupon{},
      %{
        title: "Mamma Aiuto! Prize Discount",
        value: Decimal.new(20.00),
        status: :available,
        user_id: user_three.id,
        brand_id: brand_one.id
      }
    ) |> Repo.insert!()
    
    Supervisor.stop(Repo)
  end
end