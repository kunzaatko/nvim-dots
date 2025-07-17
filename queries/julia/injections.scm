;; extends

; Inject markdown in docstrings
((string_literal
  (content) @injection.content)
  .
  (macrocall_expression)
  (#set! injection.language "markdown"))
