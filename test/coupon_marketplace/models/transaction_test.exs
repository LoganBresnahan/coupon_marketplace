defmodule CouponMarketplace.Models.TransactionTest do
  use ExUnit.Case
  alias CouponMarketplace.Models.Transaction

  @sufficient_attrs %{
    seller_id: 1,
    buyer_id: 1,
    coupon_id: 1,
    profit: Decimal.new(20.00),
    transaction_date: DateTime.utc_now()
  }

  @insufficient_attrs %{
    seller_id: 1,
    profit: Decimal.new(20.00)
  }

  test "changeset with required attributes" do
    changeset = Transaction.changeset(%Transaction{}, @sufficient_attrs)

    assert changeset.valid?
  end

  test "changeset without required attributes" do
    changeset = Transaction.changeset(%Transaction{}, @insufficient_attrs)

    refute changeset.valid?
  end

  test "schema metadata" do
    assert Transaction.__schema__(:source) == "transactions"

    assert Transaction.__schema__(:fields) == [
             :id,
             :seller_id,
             :buyer_id,
             :coupon_id,
             :profit,
             :transaction_date,
             :inserted_at,
             :updated_at
           ]

    assert Transaction.__schema__(:primary_key) == [:id]
    assert Transaction.__schema__(:autogenerate_id) == {:id, :id, :id}
  end
end
