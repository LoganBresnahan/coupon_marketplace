defmodule CouponMarketplace.Repo.Migrations.AddUserTable do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :balance, :decimal, precision: 1000, scale: 2
      add :type, :string, default: "normal"

      timestamps()
    end

    create unique_index(:users, [:username], concurrently: true)
  end
end
