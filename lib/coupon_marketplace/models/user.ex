defmodule CouponMarketplace.Models.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarketplace.Models.Coupon

  @required_fields [:username, :password, :balance, :type]

  schema "users" do
    field :username, :string
    field :password, :string
    field :balance, :decimal
    field :type, :string, default: "normal"
    has_many :coupons, Coupon

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username)
  end
end