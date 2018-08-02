defmodule CouponMarketplace.Repo.Migrations.AddBrandTable do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create table(:brands) do
      add :name, :string

      timestamps()
    end

    create unique_index(:brands, [:name], concurrently: true)
  end
end
