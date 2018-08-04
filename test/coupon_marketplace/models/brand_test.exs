defmodule CouponMarketplace.Models.BrandTest do
  use ExUnit.Case
  alias CouponMarketplace.Models.Brand

  @sufficient_attrs %{
    name: "Ghibli"
  }

  @insufficient_attrs %{}

  test "changeset with required attributes" do
    changeset = Brand.changeset(%Brand{}, @sufficient_attrs)

    assert changeset.valid?
  end

  test "changeset without required attributes" do
    changeset = Brand.changeset(%Brand{}, @insufficient_attrs)

    refute changeset.valid?
  end

  test "schema metadata" do
    assert Brand.__schema__(:source) == "brands"
    assert Brand.__schema__(:fields) == [:id, :name, :inserted_at, :updated_at]
    assert Brand.__schema__(:primary_key) == [:id]
    assert Brand.__schema__(:autogenerate_id) == {:id, :id, :id}
  end
end
