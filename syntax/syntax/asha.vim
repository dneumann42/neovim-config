if exists("b:current_syntax")
  finish
endif

" Keywords
syntax keyword ashaKeywords if else for while function return elif then end do cond of
syntax keyword ashaSpecial def var fun
" Add more keywords as needed

" Operators
syntax match ashaOperator "\v[-+*/%=<>!&|^~]"
syntax match ashaOperator "\v(\=\=|!=|<=|>=|\<\<|\>\>|\.\.|::)"
" Add more operators as needed

" Strings
syntax region ashaString start=/"/ skip=/\\"/ end=/"/ oneline
syntax region ashaString start=/'/ skip=/\\'/ end=/'/ oneline

" Numbers
syntax match ashaNumber "\v<\d+>"
syntax match ashaFloat "\v<\d+\.\d+>"

" Comments
syntax match ashaComment "\v//.*$"
syntax region ashaComment start="/\*" end="\*/"

" Function calls
syntax match ashaFunction "\v<\w+>\ze\s*\("

" Constants
syntax keyword ashaConstant true false null
" Add more constants as needed

" Define highlight links
highlight default link ashaKeywords Keyword
highlight default link ashaOperator Operator
highlight default link ashaString String
highlight default link ashaNumber Number
highlight default link ashaFloat Float
highlight default link ashaComment Comment
highlight default link ashaFunction Function
highlight default link ashaConstant Constant
highlight default link ashaSpecial Structure

let b:current_syntax = "asha"
