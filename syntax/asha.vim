if exists("b:current_syntax")
  finish
endif

set iskeyword=a-z,A-Z,-,*,_,!,@

syntax keyword ashaTodos TODO XXX FIXME NOTE

syntax keyword ashaKeywords if def fun then else elif end do in case cond of set while and or for when let var iter module struct trait
syntax keyword ashaSpecial true false = ~= echo arg yield
syntax match ashaSpecialChar /[(){}\[\]]/
syntax keyword ashaOperator + / - * % ^ @ ! = eq ":="
syntax keyword ashaType arg

syntax match ashaInt "\<\d\+\>"
syntax match ashaInt "\<0[xX][[:xdigit:].]\+\%([pP][-+]\=\d\+\)\=\>"
syntax match ashaFloat "\<\d\+\.\d*\%([eE][-+]\=\d\+\)\=\>"
syntax match ashaFloat "\.\d\+\%([eE][-+]\=\d\+\)\=\>"
syntax match ashaFloat "\<\d\+[eE][-+]\=\d\+\>"

syntax region ashaString start=/\v"/ skip=/\v\\./ end=/\v"/
syntax region ashaComment start=/;/ end=/$/
syntax keyword ashaNil nil
syntax match ashaFnCall /\k\+\%(\s*(\)\@=/

highlight default link ashaTodos Todo
highlight default link ashaNil Number
highlight default link ashaKeywords Keyword
highlight default link ashaFnCall Function
highlight default link ashaFloat Number
highlight default link ashaInt Number
highlight default link ashaString String
highlight default link ashaComment Comment
highlight default link ashaOperator Operator
highlight default link ashaType Type
highlight default link ashaSpecial Special
highlight default link ashaSpecialChar Label

let b:current_syntax = "asha"
