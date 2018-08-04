defmodule CouponMarketplace.Screens.Deposit do
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Utils.NewIO
  alias CouponMarketplace.Models.User
  alias CouponMarketplace.Repo

  @moduledoc """
  The Deposit Screen is where a user deposits more money.
  """

  def present(current_state) do
    IO.puts """

    ~~~~~~~~~~ Deposit ~~~~~~~~~~

    Please Enter a deposit amount or press "u"
    to go back to your profile.
    """

    input = NewIO.gets("> ")

    cond do
      Regex.match?(~r/^\d+\.\d{2}$/, input) ->
        deposit(current_state, input)
      input == "u" ->
        %{current_state | screen: :user}
        |> StateTree.write()
      true ->
        IO.puts "********** Enter a valid number with two decimal points. Ex: 20.00 **********"
    end
  end

  defp deposit(current_state, input) do
    Task.async(fn -> 
      get_user(current_state) 
      |> update_deposit(input) 
    end)
    |> Task.await()
    |> handle_balance_update(current_state)
  end

  defp get_user(current_state) do
    Repo.get_by(User, username: current_state.user.username)
    |> case do
      nil ->
        IO.puts "********** Error with your username. Logging you out **********"

        :error
      schema ->
        schema
    end
  end

  defp update_deposit(:error, _) do
    {:error, nil}
  end
  defp update_deposit(user_record, new_deposit) do
    User.changeset(
      user_record,
      %{
        balance: Decimal.add(user_record.balance, new_deposit)
      }
    ) |> Repo.update()
  end

  defp handle_balance_update({:error, nil}, _) do
    StateTree.write(%{screen: :new_session})

    NewIO.press_enter
  end
  defp handle_balance_update({:error, changeset}, current_state) do
    Instructions.help(:deposit, changeset)

    input = NewIO.gets("> ")

    case input do
      "t" ->
        present(current_state)
      "lo" ->
        StateTree.write(%{screen: :new_session})
      "u" ->
        %{current_state | screen: :user}
        |> StateTree.write()
      _ ->
        IO.puts "Input not supported."

        NewIO.press_enter
    end
  end
  defp handle_balance_update({:ok, schema}, current_state) do
    IO.puts "$$$$$$$$$$ Successfully updated your balance. $$$$$$$$$$\n"

    %{current_state | screen: :user}
    |> update_in([:user, :balance], &(&1 = schema.balance))
    |> StateTree.write()

    NewIO.press_enter
  end
end