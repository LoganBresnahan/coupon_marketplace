defmodule CouponMarketplace.Models.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarketplace.Models.Coupon
  alias CouponMarketplace.Models.Transaction

  @moduledoc """
  The User Model

  A unique constraint at the database level for the username.
  Most users unless specially created outside of the interface
  are "normal", as in, not an admin.
  A user has associations with coupons, and transactions.
  """

  @required_fields [:username, :password, :balance, :type]

  schema "users" do
    field :username, :string
    field :password, :string
    field :balance, :decimal
    field :type, :string, default: "normal"
    has_many :coupons, Coupon
    has_many :sales, Transaction, foreign_key: :seller_id
    has_many :purchases, Transaction, foreign_key: :buyer_id

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username)
  end
end