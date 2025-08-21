;; TODO: Capture for a `@doc raw""` to be detected as a documentation string <21-08-25> 
;; extends

; Inject markdown in docstrings above macros
((string_literal
  (content) @injection.content)
  .
  (macrocall_expression)
  (#set! injection.language "markdown"))
