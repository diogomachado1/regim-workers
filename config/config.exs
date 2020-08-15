use Mix.Config

config :import_massive, Products.Repo,
  database: "import_massive_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :ex_aws,
  access_key_id: "notValidKey",
  secret_access_key: "notValidSecret",
  region: "eu-central-1",
  sqs: [
    host: "127.0.0.1",
    port: "9324",
    scheme: "http"
  ]

config :ex_aws, :hackney_opts,
  follow_redirect: true,
  recv_timeout: 30_000

config :ex_aws,
  json_codec: Jason

config :ex_aws_sqs, parser: ExAws.SQS.SweetXmlParser

config :remix,
  escript: true,
  silent: true

config :joken, default_signer: "secret"
