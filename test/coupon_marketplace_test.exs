defmodule CouponMarketplaceTest do
  use ExUnit.Case, async: false

  describe "start/2" do
    test "CouponMarketplace.Application and child Supervisors are started" do
      assert {:ok, pid} = CouponMarketplace.start(nil, nil)
      assert {:error, {:already_started, _pid}} = CouponMarketplace.start(nil, nil)

      [
        {CouponMarketplace.Repo, repo_pid, :supervisor, [CouponMarketplace.Repo]}
      ] = Supervisor.which_children(CouponMarketplace.Application)

      assert Process.alive?(pid) == true
      assert Process.alive?(repo_pid) == true
    end
  end
end
