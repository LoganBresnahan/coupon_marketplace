defmodule CouponMarketplace.Models.Coupon do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Models.Brand

  @moduledoc """
  The Coupon Model

  The coupon model utilized the StatusEnum type. This uses
  Postgres's Enum type under the hood. I like enums in the place
  of what might be a boolean type. Booleans are not extensible,
  and you often have to add another boolean field in the future
  to symbolize another factor about the record. This causes the
  unecessary addition of more columns over time. An Enum type gives
  use more flexability for the future. I've added the ecto_enum
  package to accomplish this. It is defined here:
  /coupon_marketplace/lib/coupon_marketplace/enum.ex
  """

  @required_fields [:title, :value, :status, :user_id, :brand_id]

  schema "coupons" do
    field(:title, :string)
    field(:value, :decimal)
    field(:status, StatusEnum)
    belongs_to(:user, User)
    belongs_to(:brand, Brand)

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
