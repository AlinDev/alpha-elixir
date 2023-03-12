defmodule Webui.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WebuiWeb.Telemetry,
      # Start the Ecto repository
      # Webui.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Webui.PubSub},
      # Start Finch
      {Finch, name: Webui.Finch},
      # Start the Endpoint (http/https)
      WebuiWeb.Endpoint
      # Start a worker by calling: Webui.Worker.start_link(arg)
      # {Webui.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Webui.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WebuiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
