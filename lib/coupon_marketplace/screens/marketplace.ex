defmodule CouponMarketplace.Screens.Marketplace do
  require Logger
  import Ecto.Query
  alias CouponMarketplace.Utils.NewIO
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.Coupon
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Models.Brand
  alias CouponMarketplace.Models.Transaction
  alias CouponMarketplace.Repo

  @moduledoc """
  The Maketplace Screen is where a user can go to buy
  a coupon.

  The actual updating of the four different records are
  wrapped inside of a Repo transaction block to ensure
  that if one fails the transaction will be rolled back
  and none of the records would change. This ensures that
  the transaction process goes through for all parties,
  Buyer, Seller, Coupon, and Transaction.
  """

  def present(current_state) do
    IO.puts """

    ~~~~~~~~~~ The Marketplace ~~~~~~~~~~

    #{display_coupons(coupons_for_sale(current_state))}
    
    What would you like to do?
    "b" buy a coupon
    "u" your profile
    "lo" logout
    """

    input = NewIO.gets("> ")

    case input do
      "b" ->
        transaction(current_state)
      "u" ->
        %{current_state | screen: :user}
        |> StateTree.write()
      "lo" ->
        StateTree.write(%{screen: :new_session})
      _ ->
        IO.puts "Input not supported."

        NewIO.press_enter
    end
  end

  defp coupons_for_sale(current_state) do
    from(coupon in Coupon,
      join: brand in Brand, on: coupon.brand_id == brand.id,
      where: coupon.status == ^:available
      and coupon.user_id != ^current_state.user.id,
      preload: [:brand, :user],
      order_by: [desc: brand.name],
      select: coupon
    ) |> Repo.all()
  end

  defp display_coupons(coupons) do
    coupons
    |> Enum.reduce("", fn(coupon, acc) -> 
      """
      Brand: #{coupon.brand.name}
      Owner: #{coupon.user.username}
      ID: #{coupon.id}
      Title: #{coupon.title}
      Value: #{coupon.value}\n
      """ <> acc
    end)
  end

  defp transaction(current_state) do
    with {:ok, coupon} <- get_coupon(current_state),
        {:ok, seller} <- get_seller(coupon),
        {:ok, buyer} <- get_buyer(current_state),
        :ok <- sufficient_funds(buyer.balance >= coupon.value)
    do
      house_profit = Decimal.mult(coupon.value, Decimal.new(0.05))

      update_all_parties(coupon, seller, buyer, house_profit)
      |> case do
        {:ok, _} ->
          IO.puts "$$$$$$$$$$ Success! $$$$$$$$$$"

          NewIO.press_enter
          current_state
          |> update_in([:user, :balance], &(&1 = Decimal.sub(&1, coupon.value)))
          |> StateTree.write()
        _ ->
          IO.puts "********** Sorry, and internal error has occured during the transaction process. **********"

          NewIO.press_enter
      end
    else
      message ->
        IO.puts message

        NewIO.press_enter
    end
  end

  defp update_all_parties(coupon, seller, buyer, house_profit) do
    Repo.transaction(fn ->
      try do
        update_coupon!(coupon, buyer)
        update_seller!(seller, coupon, house_profit)
        update_buyer!(buyer, coupon)
        create_transaction_record!(coupon, seller, buyer, house_profit)
      rescue error in [Ecto.InvalidChangesetError] ->
        Logger.error inspect(error)

        Repo.rollback(:transaction_failure)
      end
    end)
  end

  defp update_coupon!(coupon, buyer) do
    Coupon.changeset(
      coupon,
      %{
        user_id: buyer.id,
        status: :unavailable
      }
    ) |> Repo.update!()
  end

  defp update_seller!(seller, coupon, house_profit) do
    new_balance = Decimal.sub(coupon.value, house_profit)
    |> Decimal.add(seller.balance)

    User.changeset(
      seller,
      %{
        balance: new_balance
      }
    ) |> Repo.update!()
  end

  defp update_buyer!(buyer, coupon) do
    new_balance = Decimal.sub(buyer.balance, coupon.value)

    User.changeset(
      buyer,
      %{
        balance: new_balance
      }
    ) |> Repo.update!()
  end

  defp create_transaction_record!(coupon, seller, buyer, house_profit) do
    Transaction.changeset(
      %Transaction{},
      %{
        seller_id: seller.id,
        buyer_id: buyer.id,
        coupon_id: coupon.id,
        profit: house_profit,
        transaction_date: DateTime.utc_now()
      }
    ) |> Repo.insert!()
  end

  defp get_coupon(current_state) do
    coupon_id = choose_coupon()

    from(coupon in Coupon,
      where: coupon.id == ^coupon_id
      and coupon.status == ^:available
      and coupon.user_id != ^current_state.user.id,
      select: coupon
    ) 
    |> Repo.one()
    |> case do
      nil ->
        "********** Error Finding Coupon: #{coupon_id} **********"
      schema ->
        {:ok, schema}
    end
  end

  defp choose_coupon do
    IO.puts "Select a coupon by its ID."

    input = NewIO.gets("> ")

    if Regex.match?(~r/^\d+$/, input) do
      input
    else
      choose_coupon()
    end
  end

  defp get_seller(coupon) do
    case Repo.get(User, coupon.user_id) do
      nil ->
        "********** Error Finding Seller **********"
      schema ->
        {:ok, schema}
    end
  end

  defp get_buyer(current_state) do
    case Repo.get(User, current_state.user.id) do
      nil ->
        "********** Error Retrieving Your Balance **********"
      schema ->
        {:ok, schema}
    end
  end

  defp sufficient_funds(true), do: :ok
  defp sufficient_funds(false) do
    "********** Insufficient Funds **********"
  end
end