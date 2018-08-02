defmodule CouponMarketplace.Repo.Migrations.AddUserTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :balance, :decimal, precision: 2

      timestamps()
    end

    execute "END;"
    create unique_index(:users, [:username], concurrently: true)
    execute "BEGIN;"
  end
end
