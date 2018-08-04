defmodule CouponMarketplace.Screens.User do
  import Ecto.Query
  alias CouponMarketplace.Utils.Instructions
  alias CouponMarketplace.Utils.NewIO
  alias CouponMarketplace.Interface.StateTree
  alias CouponMarketplace.Models.Coupon
  alias CouponMarketplace.Models.Brand
  alias CouponMarketplace.Repo

  @moduledoc """
  The User Screen is where a user can view their coupons,
  update their coupon status, and deposit more money.

  I also think this module is a candidate for caching
  the users coupons for viewing. Possibly adding them
  to the StateTree and then updating them when
  necessary.
  """

  def present(current_state) do
    IO.puts """
    
    ~~~~~~~~~~ User Profile ~~~~~~~~~~

    Username: #{current_state.user.username}
    Balance: #{current_state.user.balance}
    Coupons: \n\n#{display_coupons(current_state)}
    
    What would you like to do?
    "a" add a new coupon
    "p" post coupon for sale or rescind from sale
    "r" request a coupon
    "d" deposit more money
    "lo" logout
    """

    input = NewIO.gets("> ")

    case input do
      "a" ->
        add_new_coupon(current_state)
      "p" ->
        post_or_rescind_coupon(current_state)
      "r" ->
        %{current_state | screen: :marketplace}
        |> StateTree.write()
      "d" ->
        %{current_state | screen: :deposit}
        |> StateTree.write()
      "lo" ->
        StateTree.write(%{screen: :new_session})
      _ ->
        IO.puts "Input not supported."

        NewIO.press_enter
    end
  end

  defp display_coupons(current_state) do
    coupons(current_state)
    |> Enum.reduce("", fn(coupon, acc) -> 
      """
      Brand: #{coupon.brand.name}
      ID: #{coupon.id}
      Title: #{coupon.title}
      Value: #{coupon.value}
      Marketplace Status: #{coupon.status}\n
      """ <> acc
    end)
  end

  defp coupons(current_state) do
    from(coupon in Coupon,
      join: brand in Brand, on: coupon.brand_id == brand.id,
      where: coupon.brand_id == brand.id
      and coupon.user_id == ^current_state.user.id,
      preload: [:brand],
      order_by: [desc: brand.name],
      select: coupon
    ) |> Repo.all()
  end

  defp add_new_coupon(current_state) do
    {brand, title, value, status} = get_coupon_details()
        
    Task.async(fn -> 
      create_or_update_brand(brand) 
      |> create_coupon(current_state, {title, value, status}) 
    end)
    |> Task.await()
    |> handle_coupon_result(current_state)
  end

  defp get_coupon_details() do
    IO.puts "Brand Name?"
    brand = NewIO.gets_title("> ")

    IO.puts "Coupon Title?"
    title = NewIO.gets_title("> ")

    value = get_value()

    status = get_status()
    
    {brand, title, value, status}
  end

  defp get_value do
    IO.puts "Value?"
    value = NewIO.gets("> ")

    if Regex.match?(~r/^\d+\.\d{2}$/, value) do
      value
    else
      IO.puts "********** Enter a valid number with two decimal points. Ex: 20.00 **********"

      get_value()
    end
  end

  defp create_or_update_brand(name) do
    case Repo.get_by(Brand, name: name) do
      nil ->
        %Brand{}
      brand ->
        brand
    end
    |> Brand.changeset(
      %{
        name: name
      }
    ) |> Repo.insert_or_update()
  end

  defp create_coupon({:error, changeset}, _, _) do
    {:error, changeset}
  end
  defp create_coupon({:ok, brand}, current_state, {title, value, status}) do
    Coupon.changeset(
      %Coupon{},
      %{
        title: title,
        value: Decimal.new(value),
        status: status,
        user_id: current_state.user.id,
        brand_id: brand.id
      }
    ) |> Repo.insert()
  end

  defp post_or_rescind_coupon(current_state) do
    coupon = choose_coupon()
    status = get_status()

    Task.async(fn ->
      get_coupon(coupon, current_state)
      |> update_coupon(status)
    end)
    |> Task.await()
    |> handle_coupon_result(current_state)
  end

  defp choose_coupon do
    IO.puts "Choose a coupon from your list by its ID."

    input = NewIO.gets("> ")

    if Regex.match?(~r/^\d+$/, input) do
      input
    else
      choose_coupon()
    end
  end

  defp get_status do
    IO.puts "Marketplace Status? (1 available to buy or 2 unavailable to buy)"

    input = NewIO.gets("> ")

    case input do
      "1" ->
        IO.puts "\nA 5% house fee is collected when sold.\n"

        :available
      "2" ->
        :unavailable
      _ ->
        get_status()
    end
  end

  defp get_coupon(input, current_state) do
    case Repo.get_by(Coupon, [id: input, user_id: current_state.user.id]) do
      nil ->
        :error
      schema ->
        schema
    end
  end

  defp update_coupon(:error, _) do
    IO.puts "********** Coupon Not Found **********"

    :error
  end
  defp update_coupon(schema, status) do
    Coupon.changeset(
      schema,
      %{
        status: status
      }
    ) |> Repo.update()
  end

  defp handle_coupon_result(:error, _) do
    NewIO.press_enter
  end
  defp handle_coupon_result({:error, changeset}, current_state) do
    Instructions.help(:coupon, changeset)

    input = NewIO.gets("> ")

    case input do
      "lo" ->
        StateTree.write(%{screen: :new_session})
      "u" ->
        present(current_state)
      _ ->
        IO.puts "Input not supported."

        NewIO.press_enter
    end
  end
  defp handle_coupon_result({:ok, schema}, _) do
    IO.puts "$$$$$$$$$$ Success for, #{schema.title} $$$$$$$$$$"

    NewIO.press_enter
  end
end