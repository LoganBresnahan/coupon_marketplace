defmodule CouponMarketplace.Models.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Models.Coupon

  @moduledoc """
  The Transaction Model

  A transaction belongs to a coupon, and two user records (seller, buyer).

  There is an index on the profit column. The reason for this, is so an
  admin can generate a report of the total profit quickly. Another option
  would have been to have some other object keep a running total of all
  profits, but I prefer this. I think there would be less room
  for error when auditing the total for different reporting scenarios.
  """

  @required_fields [:seller_id, :buyer_id, :coupon_id, :profit, :transaction_date]

  schema "transactions" do
    belongs_to(:seller, User, foreign_key: :seller_id)
    belongs_to(:buyer, User, foreign_key: :buyer_id)
    belongs_to(:coupon, Coupon)
    field(:profit, :decimal)
    field(:transaction_date, :naive_datetime)

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
