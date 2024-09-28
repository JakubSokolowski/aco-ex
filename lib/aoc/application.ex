defmodule Aoc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AocWeb.Telemetry,
      Aoc.Repo,
      {DNSCluster, query: Application.get_env(:aoc, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Aoc.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Aoc.Finch},
      # Start a worker by calling: Aoc.Worker.start_link(arg)
      # {Aoc.Worker, arg},
      # Start to serve requests, typically the last entry
      AocWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aoc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AocWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
