if exists("b:current_syntax")
  finish
endif

set iskeyword=a-z,A-Z,-,*,_,!,@

syntax keyword owlTodos TODO XXX FIXME NOTE

syntax keyword owlKeywords if def fun then else end do in case cond of set while and or for when let var iter module struct trait
syntax keyword owlSpecial #t #f = ~= echo arg yield
syntax match owlSpecialChar /[(){}\[\]]/
syntax keyword owlOperator + / - * % ^ @ ! =
syntax keyword owlType arg

syntax match owlInt "\<\d\+\>"
syntax match owlInt "\<0[xX][[:xdigit:].]\+\%([pP][-+]\=\d\+\)\=\>"
syntax match owlFloat "\<\d\+\.\d*\%([eE][-+]\=\d\+\)\=\>"
syntax match owlFloat "\.\d\+\%([eE][-+]\=\d\+\)\=\>"
syntax match owlFloat "\<\d\+[eE][-+]\=\d\+\>"

syntax region owlString start=/\v"/ skip=/\v\\./ end=/\v"/
syntax region owlComment start=/;/ end=/$/
syntax keyword owlNil nil
syntax match owlFnCall /\k\+\%(\s*(\)\@=/

highlight default link owlTodos Todo
highlight default link owlNil Number
highlight default link owlKeywords Keyword
highlight default link owlFnCall Function
highlight default link owlFloat Number
highlight default link owlInt Number
highlight default link owlString String
highlight default link owlComment Comment
highlight default link owlOperator Operator
highlight default link owlType Type
highlight default link owlSpecial Special
highlight default link owlSpecialChar Label

let b:current_syntax = "owl"
