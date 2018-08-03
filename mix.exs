defmodule CouponMarketplace.MixProject do
  use Mix.Project

  @moduledoc """
  Notes on Functions:

  load_app_by_env/1 
  is a private function I have used in a few projects.
  Its purpose is to keep the application from starting in the test
  evironment. Often, I like to test starting and shutting down supervised
  processes in the supervision tree. Keeping them from starting automatically
  when running "mix test" is convenient for this purpose.

  Misc Notes:
  
  Inside the ecto.setup command you might notice a "seed" task.
  This is a custom seed task and an explanation can be found in the
  moduledoc of the file, /coupon_marketplace/lib/coupon_marketplace/mix/tasks/seed.ex
  """

  def project do
    [
      app: :coupon_marketplace,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: load_app_by_env(Mix.env()),
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:ecto_enum, "~> 1.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:decimal, "~> 1.0"},
      {:mox, "~> 0.3", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp load_app_by_env(:test), do: []
  defp load_app_by_env(_), do: {CouponMarketplace, []}

  defp elixirc_paths(_), do: ["lib"]
end
