Mox.defmock(CouponMarketplace.Utils.NewIOMock, for: CouponMarketplace.Utils.NewIO)
Application.ensure_all_started(:mox)
ExUnit.start()
