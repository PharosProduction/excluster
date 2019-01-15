Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

erlang_cookie = :sha256
|> :crypto.hash(System.get_env("ERLANG_COOKIE") || "/hdNA305fOYse3Rhak3qXn7CFJ/2zugbChgrnVm/M4HKRXGp0PDi7BFJpUaEaqaN")
|> Base.encode16
|> String.to_atom

use Mix.Releases.Config,
  default_release: :excluster,
  default_environment: Mix.env()

release :excluster do
  set version: "1.0.0"
  set applications: [
    runtime_tools: :transient,
    sasl: :transient,
    logger: :transient,
    observer: :transient,
    wx: :transient,
    core: :permanent,
    api_mobile: :permanent
  ]
end

environment :stage do
  set dev_mode: false
  set include_erts: true
  set include_system_libs: true
  set include_src: false
  set cookie: erlang_cookie
  set vm_args: "rel/vm.args/stage.vm.args"
  set pre_configure_hooks: "rel/hooks/pre_configure.d"
  set overlays: [
    {:copy, "rel/config/config_stage.toml", "etc/config_stage.toml"}
  ]
  set overlay_vars: [
    release_name: "excluster"
  ]
  set config_providers: [
    {Toml.Provider, path: "${RELEASE_ROOT_DIR}/etc/config_stage.toml", transforms: []}
  ]
end

environment :prod do
  set dev_mode: false
  set include_erts: true
  set include_system_libs: true
  set include_src: false
  set cookie: erlang_cookie
  set vm_args: "rel/vm.args/prod.vm.args"
  set pre_configure_hooks: "rel/hooks/pre_configure.d"
  set overlays: [
    {:copy, "rel/config/config_prod.toml", "etc/config_prod.toml"}
  ]
  set overlay_vars: [
    release_name: "excluster"
  ]
  set config_providers: [
    {Toml.Provider, path: "${RELEASE_ROOT_DIR}/etc/config_prod.toml", transforms: []}
  ]
end