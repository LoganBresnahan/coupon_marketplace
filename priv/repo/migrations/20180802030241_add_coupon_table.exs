defmodule CouponMarketplace.Repo.Migrations.AddCouponTable do
  use Ecto.Migration

  def change do
    StatusEnum.create_type

    create table(:coupons) do
      add :title, :string
      add :value, :decimal, precision: 1000, scale: 2
      add :status, :status
      add :user_id, references(:users, on_delete: :delete_all)
      add :brand_id, references(:brands)

      timestamps()
    end
  end
end
