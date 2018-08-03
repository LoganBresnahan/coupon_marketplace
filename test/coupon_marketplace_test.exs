defmodule CouponMarketplaceTest do
  # use ExUnit.Case
  # import Mox
  # alias CouponMarketplace.Utils.NewIOMock

  # setup :set_mox_global
  # setup :verify_on_exit!

  # describe "start/2" do
  #   test "CouponMarketplace.Application and child Supervisors are started" do
  #     NewIOMock
  #     |> expect(:gets, fn(_) -> "h" end)

      

  #     assert {:ok, pid} = CouponMarketplace.start(nil, nil)
  #     assert {:error, {:already_started, _pid}} = CouponMarketplace.start(nil, nil)

  #     [
  #       {CouponMarketplace.Repo, repo_pid, :supervisor, [CouponMarketplace.Repo]}
  #     ] = Supervisor.which_children(CouponMarketplace.Application)

  #     assert Process.alive?(pid) == true
  #     assert Process.alive?(repo_pid) == true

  #     Supervisor.stop(CouponMarketplace.Interface.Router)
  #   end
  # end
end
