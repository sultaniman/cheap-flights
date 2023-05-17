# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  import_deps: [:typed_struct],
  export: [
    locals_without_parens: [field: 2, field: 3]
  ]
]
