defmodule CouponMarketplace.Models.Coupon do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Models.Brand

  @required_fields [:title, :value, :status, :user_id, :brand_id]

  schema "coupons" do
    field :title, :string
    field :value, :decimal
    field :status, StatusEnum
    belongs_to :user, User
    belongs_to :brand, Brand

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:brand_id)
  end
end