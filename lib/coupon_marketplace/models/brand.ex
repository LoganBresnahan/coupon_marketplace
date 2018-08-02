defmodule CouponMarketplace.Models.Brand do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarketplace.Models.Coupon

  @required_fields [:name]

  schema "brands" do
    field :name, :string
    has_many :coupons, Coupon

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end