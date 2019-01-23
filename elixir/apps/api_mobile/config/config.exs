use Mix.Config

config :api_mobile, ApiMobileWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  http: [:inet6, port: 4000],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  secret_key_base: "f03TxMJ63JKqSEYMbqW/LlNf1KJ8ZOLgS0UqW5nL38HgSIEBO7wJCyM0yCdS8Zfs",
  static_url: [
    scheme: "https",
    host: "localhost",
    port: 4003
  ],
  render_errors: [view: ApiMobileWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ApiMobile.PubSub, adapter: Phoenix.PubSub.PG2],
  server: true,
  watchers: []

config :phoenix, :serve_endpoints, true
config :phoenix, :format_encoders, "json-api": Jason
config :phoenix, :json_library, Jason

config :mime, :types, %{"application/vnd.api-mobile.v1+json" => [:v1]}

import_config "#{Mix.env()}.exs"
