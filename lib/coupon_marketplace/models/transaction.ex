defmodule CouponMarketplace.Models.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Models.Coupon

  @required_fields [:seller_id, :buyer_id, :coupon_id, :profit, :transaction_date]

  schema "transactions" do
    belongs_to :seller, User, foreign_key: :seller_id
    belongs_to :buyer, User, foreign_key: :buyer_id
    belongs_to :coupon, Coupon
    field :profit, :decimal
    field :transaction_date, :naive_datetime

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:seller_id)
    |> foreign_key_constraint(:buyer_id)
    |> foreign_key_constraint(:coupon_id)
  end
end