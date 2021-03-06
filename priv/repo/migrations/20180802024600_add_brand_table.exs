defmodule CouponMarketplace.Repo.Migrations.AddBrandTable do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string

      timestamps()
    end

    create unique_index(:brands, [:name])
  end
end
