defmodule CouponMarketplace.Screens.Admin do
  import Ecto.Query
  alias CouponMarketplace.Utils.NewIO
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.Transaction
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Repo

  @moduledoc """
  The Admin Screen handles the options that can
  be executed by an admin only.
  """

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

    input = NewIO.gets("> ")

    case input do
      "u" ->
        IO.puts "---------- All Users ----------"
        IO.puts list_all_users()

        NewIO.press_enter
      "t" ->
        IO.puts "--------- All Transactions ---------"
        IO.puts list_all_transactions()

        NewIO.press_enter
      "c" ->
        IO.puts calculate_revenue(0, Repo.all(Transaction))

        NewIO.press_enter
      "lo" ->
        StateTree.write(%{screen: :new_session})
      _ ->
        IO.puts "Input not supported."

        NewIO.press_enter
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