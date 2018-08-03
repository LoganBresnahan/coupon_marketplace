defmodule CouponMarketplace.Repo.Migrations.AddTransactionTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :seller_id, references(:users)
      add :buyer_id, references(:users)
      add :coupon_id, references(:coupons)
      add :profit, :decimal, precision: 1000, scale: 2
      add :transaction_date, :naive_datetime

      timestamps()
    end

    create index(:transactions, [:profit])
  end
end
