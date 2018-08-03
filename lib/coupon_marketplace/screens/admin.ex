defmodule CouponMarketplace.Screens.Admin do
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.Transaction
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Repo

  @io Application.get_env(:coupon_marketplace, :io)

  def present(current_state) do
    IO.puts """
    
    *Admin Interface*

    Logged In As: #{current_state.user.username}

    What would you like to do?
    "u" list all users.
    "t" list all transactions.
    "r" calculate total marketplace revenue.
    "lo" logout
    """

    input = @io.gets("> ")

    case input do
      "u" ->
        IO.puts list_all_users()
      "t" ->
        IO.puts list_all_transactions()
      "r" ->
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
    Repo.all(Transaction)
    |> Enum.reduce("", fn(transaction, acc) -> 
    """

    ID: #{transaction.id}
    Profit: #{transaction.profit}
    Date: #{transaction.transaction_date}\n
    """ <> acc
    end)
  end

  defp calculate_revenue(acc, []), do: "Total: #{acc}"
  defp calculate_revenue(acc, [head | tail]) do
    Decimal.add(head.profit, acc)
    |> calculate_revenue(tail)
  end
end