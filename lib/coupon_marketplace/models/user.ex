defmodule CouponMarketplace.Models.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:username, :password, :balance]

  schema "users" do
    field :username, :string
    field :password, :string
    field :balance, :decimal

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username)
  end
end