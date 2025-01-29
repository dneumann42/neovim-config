if exists("b:current_syntax")
  finish
endif

" Keywords
syntax keyword owlKeywords if else for while fun fn return elif then end do cond of def record module export method in use type ,
syntax keyword owlSpecial var def not eq noteq range
" Add more keywords as needed

" Operators
syntax match owlOperator "\v[-+*/%=<>!&|^~]"
syntax match owlOperator "\v(\=\=|!=|<=|>=|\<\<|\>\>|\.\.|::)"
" Add more operators as needed

" Strings
syntax region owlString start=/"/ skip=/\\"/ end=/"/ oneline
syntax region owlString start=/'/ skip=/\\'/ end=/'/ oneline

syntax match owlParen "[(){}[\]]"

" Numbers
syntax match owlNumber "\v<\d+>"
syntax match owlFloat "\v<\d+\.\d+>"

" Comments
syntax match owlComment "\v\;.*$"
syntax region owlComment start="/\*" end="\*/"

" Function calls
syntax match owlFunction "\v<\w+>\ze\s*\("

" Constants
syntax keyword owlConstant true false nothing
" Add more constants as needed

syntax match owlIdentifier "\v<\w+(-\w+)*>"

" Define highlight links
highlight default link owlKeywords Keyword
highlight default link owlOperator Operator
highlight default link owlString String
highlight default link owlNumber Number
highlight default link owlFloat Float
highlight default link owlComment Comment
highlight default link owlFunction Function
highlight default link owlConstant Constant
" "highlight default link owlParen Structure
highlight default link owlSpecial Structure
highlight default link owlIdentifier Identifier

let b:current_syntax = "owl"
