# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :nostr,
  ecto_repos: [Nostr.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :nostr, Nostr.Mailer, adapter: Swoosh.Adapters.Local

config :client,
  ecto_repos: [Nostr.Repo],
  generators: [context_app: :nostr, binary_id: true]

# Configures the endpoint
config :client, Client.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: Client.ErrorHTML, json: Client.ErrorJSON],
    layout: false
  ],
  pubsub_server: Nostr.PubSub,
  live_view: [signing_salt: "MM25jTAs"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.16.10",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/client/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/client/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :client,
  relays: [
    "wss://nostr-pub.wellorder.net",
    "wss://nostr.onsats.org",
    "wss://nostr-relay.wlvs.space",
    "wss://nostr.bitcoiner.social",
    "wss://relay.damus.io",
    "wss://relay.nostr.info",
    "wss://nostr-pub.semisol.dev"
  ],
  pubkey: "0000002855ad7906a7568bf4d971d82056994aa67af3cf0048a825415ac90672"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"