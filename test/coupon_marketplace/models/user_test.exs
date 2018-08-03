defmodule CouponMarketplace.Models.UserTest do
  use ExUnit.Case
  alias CouponMarketplace.Models.User

  @sufficient_attrs %{
    username: "Totoro",
    password: Bcrypt.hash_pwd_salt("super/secret"),
    balance: 20.00
  }

  @insufficient_attrs %{
    username: "Totoro",
    password: Bcrypt.hash_pwd_salt("super/secret")
  }

  test "changeset with required attributes" do
    changeset = User.changeset(%User{}, @sufficient_attrs)

    assert changeset.valid?
  end

  test "changeset without required attributes" do
    changeset = User.changeset(%User{}, @insufficient_attrs)

    refute changeset.valid?
  end

  test "schema metadata" do
    assert User.__schema__(:source) == "users"
    assert User.__schema__(:fields) == [:id, :username, :password, :balance, :type, :inserted_at, :updated_at]
    assert User.__schema__(:primary_key) == [:id]
    assert User.__schema__(:autogenerate_id) == {:id, :id, :id}
  end
end