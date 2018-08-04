defmodule CouponMarketplace.Interface.StateTreeTest do
  use ExUnit.Case
  alias CouponMarketplace.Interface.StateTree

  describe "read and write" do
    test "they read and write to the genserver" do
      start_supervised!({StateTree, [%{}]})

      assert StateTree.read() == %{}

      StateTree.write(%{screen: :login})

      assert StateTree.read() == %{screen: :login}
    end
  end
end