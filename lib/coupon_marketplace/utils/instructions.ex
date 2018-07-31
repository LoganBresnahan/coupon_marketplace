defmodule CouponMarketplace.Utils.Instructions do
  def help(state) do
    case state do
      :new_session ->
        new_session()
    end
  end

  defp new_session do
    IO.puts "Available Options:"
    IO.puts ~s("r" for register)
    IO.puts ~s("l" for login)
    IO.puts ~s("a" for admin)
    IO.puts ~s("e" for exit)
  end
end