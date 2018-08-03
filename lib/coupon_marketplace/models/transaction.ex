defmodule CouponMarketplace.Models.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:seller_id, :buyer_id, :coupon_id, :profit, :transaction_date]

  schema "transactions" do
    field :seller_id, :integer
    field :buyer_id, :integer
    field :coupon_id, :integer
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