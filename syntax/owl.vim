if exists("b:current_syntax")
  finish
endif

" Control flow
syntax keyword owlConditional if elif else
syntax keyword owlRepeat      while
syntax keyword owlBlock       do end

" Declarations / commands
syntax keyword owlKeyword     var val set fun use print

" Boolean literals
syntax keyword owlBoolean     true false

" Logical operators (word-form)
syntax keyword owlOperator    and or

" Numbers
syntax match owlNumber "\<\d\+\>"

" Strings with escape sequences
syntax region owlString start='"' skip='\\"' end='"' contains=owlEscape
syntax match  owlEscape '\\.' contained

" Comments: one, two, or three semicolons introduce a line comment
syntax match owlComment ";.*$" contains=@Spell

highlight default link owlConditional Conditional
highlight default link owlRepeat      Repeat
highlight default link owlBlock       Keyword
highlight default link owlKeyword     Keyword
highlight default link owlBoolean     Boolean
highlight default link owlOperator    Operator
highlight default link owlNumber      Number
highlight default link owlString      String
highlight default link owlEscape      SpecialChar
highlight default link owlComment     Comment

let b:current_syntax = "owl"
