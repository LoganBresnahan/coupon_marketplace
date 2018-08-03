defmodule CouponMarketplace.Screens.Admin do
  import Ecto.Query
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.Transaction
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Repo

  @io Application.get_env(:coupon_marketplace, :io)

  def present(current_state) do
    IO.puts """
    
    ~~~~~~~~~~ Admin Interface ~~~~~~~~~~

    Logged In As: #{current_state.user.username}

    What would you like to do?
    "u" list all users.
    "t" list all transactions.
    "c" calculate total marketplace revenue.
    "lo" logout
    """

    input = @io.gets("> ")

    case input do
      "u" ->
        IO.puts list_all_users()
      "t" ->
        IO.puts list_all_transactions()
      "c" ->
        IO.puts calculate_revenue(0, Repo.all(Transaction))
      "lo" ->
        StateTree.write(%{screen: :new_session})
      _ ->
        present(current_state)
    end
  end

  defp list_all_users do
    Repo.all(User)
    |> Enum.reduce("", fn(user, acc) -> 
      """

      Username: #{user.username}
      Type: #{user.type}
      Balance: #{user.balance}\n
      """ <> acc
    end)
  end

  defp list_all_transactions do
    from(transaction in Transaction,
      preload: [:seller, :buyer],
      order_by: transaction.transaction_date,
      select: transaction
    )
    |> Repo.all()
    |> Enum.reduce("", fn(transaction, acc) -> 
    """

    ID: #{transaction.id}
    Profit: #{transaction.profit}
    Date/Time: #{transaction.transaction_date}
    Seller: #{transaction.seller.username}
    Buyer: #{transaction.buyer.username}\n
    """ <> acc
    end)
  end

  defp calculate_revenue(acc, []), do: "Total: #{acc}"
  defp calculate_revenue(acc, [head | tail]) do
    Decimal.add(head.profit, acc)
    |> calculate_revenue(tail)
  end
end