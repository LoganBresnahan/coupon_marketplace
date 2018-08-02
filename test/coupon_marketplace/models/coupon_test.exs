defmodule CouponMarketplace.Models.CouponTest do
  use ExUnit.Case
  alias CouponMarketplace.Models.Coupon

  @sufficient_attrs %{
    title: "Ghibli Museum",
    value: Decimal.new("25.00"),
    status: :available,
    user_id: 1
  }

  @insufficient_attrs %{
    title: "Ghibli Theme Park",
    value: Decimal.new("40.00")
  }

  test "changeset with required attributes" do
    changeset = Coupon.changeset(%Coupon{}, @sufficient_attrs)

    assert changeset.valid?
  end

  test "changeset without required attributes" do
    changeset = Coupon.changeset(%Coupon{}, @insufficient_attrs)

    refute changeset.valid?
  end

  test "schema metadata" do
    assert Coupon.__schema__(:source) == "coupons"
    assert Coupon.__schema__(:fields) == [:id, :title, :value, :status, :user_id, :brand_id, :inserted_at, :updated_at]
    assert Coupon.__schema__(:primary_key) == [:id]
    assert Coupon.__schema__(:autogenerate_id) == {:id, :id, :id}
  end
end