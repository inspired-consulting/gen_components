# Used by "mix format"
[
  plugins: [Phoenix.LiveView.HTMLFormatter],
  import_deps: [:phoenix],
  inputs: ["*.{heex,ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{heex,ex,exs}"],
  line_length: 180,
  heex_line_length: 200
]
