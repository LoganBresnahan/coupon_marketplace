defmodule CouponMarketplace.Utils.InstructionsTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias CouponMarketplace.Utils.Instructions

  @mock_changeset %{
    errors: [
      {:name, {"name can't be blank", []}}
    ]
  }

  describe "help/2" do
    test "when :register is passed in it formats a changeset and puts text" do
      assert capture_io(fn ->
        Instructions.help(:register, @mock_changeset)
      end) =~ "\n********** Error attempting to register. **********\nname name can't be blank\n\n\nWhat would you like to do?\n\"r\" register\n\"l\" login\n\"e\" exit\n\n"
    end

    test "when :deposit is passed in it formats a changeset and puts text" do
      assert capture_io(fn ->
        Instructions.help(:deposit, @mock_changeset)
      end) =~ "\n********** Error updating your balance **********\nname name can't be blank\n\n\nWhat would you like to do?\n\"t\" try again\n\"lo\" logout\n\"u\" your profile page\n\n"
    end

    test "when :coupon is passed in it formats a changeset and puts text" do
      assert capture_io(fn ->
        Instructions.help(:coupon, @mock_changeset)
      end) =~ "\n********** Error creating coupon **********\nname name can't be blank\n\n\nWhat would you like to do?\n\"lo\" logout\n\"u\" your profile page\n\n"
    end
  end
end