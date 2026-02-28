if exists("b:current_syntax")
  finish
endif

" ── Case-insensitive matching (Nim identifiers are style-insensitive) ──────
syntax case ignore

" ── Control flow ──────────────────────────────────────────────────────────
syntax keyword nimConditional   if elif else when case of
syntax keyword nimRepeat        for while
syntax keyword nimException     try except finally raise
syntax keyword nimLabel         break continue return

" ── Declaration / definition keywords ─────────────────────────────────────
syntax keyword nimDef           proc func method iterator converter
  \ nextgroup=nimDefName skipwhite
syntax keyword nimTypeDef       type object tuple enum distinct concept
syntax keyword nimMacro         macro template
  \ nextgroup=nimDefName skipwhite
syntax keyword nimKeyword       let var const result
syntax keyword nimKeyword       import from export include
syntax keyword nimKeyword       block do end in notin is isnot not and or xor
syntax keyword nimKeyword       bind mixin using discard discardable
syntax keyword nimKeyword       static out ptr ref addr
syntax keyword nimKeyword       yield await async
syntax keyword nimKeyword       cast sizeof typeof low high

" ── Definition target: procedure/func/template/macro name ─────────────────
syntax match nimDefName "\<[A-Za-z_][A-Za-z0-9_]*\>" contained
  \ nextgroup=nimDefArgs skipwhite

" ── Boolean & special literals ────────────────────────────────────────────
syntax keyword nimBoolean       true false on off
syntax keyword nimSpecial       nil

" ── Built-in types ────────────────────────────────────────────────────────
syntax keyword nimType
  \ int int8 int16 int32 int64
  \ uint uint8 uint16 uint32 uint64
  \ float float32 float64 float128
  \ complex complex32 complex64
  \ bool char string cstring
  \ pointer void auto untyped typed
  \ Ordinal SomeInteger SomeFloat SomeNumber SomeOrdinal
  \ seq array openArray varargs
  \ set range slice
  \ tuple object enum
  \ Future Channel

" ── Pragmas: {. ... .} ────────────────────────────────────────────────────
syntax region nimPragma start="{\.}" end=/"/ transparent keepend
syntax region nimPragma start="{\..*\." end="\.\}"
  \ contains=nimPragmaKey,nimPragmaVal
syntax keyword nimPragmaKey contained
  \ noSideEffect raises tags locks gcsafe deprecated used
  \ exportc importc importcpp importobjc cdecl stdcall safecall
  \ fastcall syscall noconv varargs pure header dynlib
  \ compileTime inline noinline final inheritable acyclic
  \ shallow uninitialized compiletime inject dirty discardable
  \ noreturn push pop hint warning error line
  \ experimental define

" ── Numbers ───────────────────────────────────────────────────────────────
" integers (decimal, hex, octal, binary) with optional type suffix
syntax match nimNumber
  \ "\<\d[0-9_]*\%([eE][+-]\?\d[0-9_]*\)\?\%(i8\|i16\|i32\|i64\|u8\|u16\|u32\|u64\|f32\|f64\|f128\|\)\>"
syntax match nimNumber
  \ "\<0x[0-9A-Fa-f][0-9A-Fa-f_]*\%([uU]\?[iI]\?\d*\)\>"
syntax match nimNumber
  \ "\<0o[0-7][0-7_]*\%([uU]\?[iI]\?\d*\)\>"
syntax match nimNumber
  \ "\<0b[01][01_]*\%([uU]\?[iI]\?\d*\)\>"
" floats
syntax match nimFloat
  \ "\<\d[0-9_]*\.\d[0-9_]*\%([eE][+-]\?\d[0-9_]*\)\?\%(f32\|f64\|f128\|\)\>"
syntax match nimFloat
  \ "\<\d[0-9_]*[eE][+-]\?\d[0-9_]*\%(f32\|f64\|f128\|\)\>"

" ── Character literal ─────────────────────────────────────────────────────
syntax match nimChar "'[^\\]'"
syntax match nimChar "'\\[nrtfvabe\\''\"0]'"
syntax match nimChar "'\\x[0-9A-Fa-f]\{2}'"

" ── Regular string (double-quoted) ────────────────────────────────────────
syntax region nimString start='"' skip='\\"' end='"'
  \ contains=nimStringEscape,nimStringInterp

" ── Raw string:  r"..." or R"..." ─────────────────────────────────────────
syntax region nimRawString start='[rR]"' end='"'

" ── Generalised raw string: ident"..." ────────────────────────────────────
syntax region nimCallString matchgroup=nimCallStringDelim
  \ start='\<[A-Za-z_][A-Za-z0-9_]*\zs"' end='"'

" ── Long / triple-quoted string ───────────────────────────────────────────
syntax region nimLongString start='"""' end='"""' keepend

" ── String interpolation: &"..." with {expr} ──────────────────────────────
syntax region nimFmtString start='&"' skip='\\"' end='"'
  \ contains=nimFmtInterp,nimStringEscape
syntax region nimFmtInterp start='{' end='}' contained
  \ contains=nimNumber,nimFloat,nimBoolean,nimType

" ── Escape sequences ──────────────────────────────────────────────────────
syntax match nimStringEscape '\\[nrtfvabe\\''\"0]' contained
syntax match nimStringEscape '\\x[0-9A-Fa-f]\{2}' contained
syntax match nimStringEscape '\\u[0-9A-Fa-f]\{4}' contained
syntax match nimStringEscape '\\u{[0-9A-Fa-f]\+}' contained

" ── Comments ──────────────────────────────────────────────────────────────
syntax region nimComment     start="#[^#]"   end="$" contains=nimTodo,@Spell
syntax region nimComment     start="#$"       end="$" contains=nimTodo,@Spell
syntax region nimDocComment  start="##"       end="$" contains=nimTodo,@Spell
syntax region nimBlockComment start="#\[" end="\]#" fold
  \ contains=nimBlockComment,nimTodo,@Spell

syntax keyword nimTodo contained TODO FIXME HACK XXX NOTE

" ── Operators & punctuation ───────────────────────────────────────────────
syntax match nimOperator "[-+*/<>=!&|^~@%]"
syntax match nimOperator "\.\."
syntax match nimOperator "\.\.\."
syntax match nimOperator ":="
syntax match nimOperator "=>"
syntax match nimOperator "->"
syntax match nimOperator "\*\*"
syntax match nimDelimiter "[(){}\[\],;:]"

" ── Type annotations ──────────────────────────────────────────────────────
syntax match nimTypeAnnotation ":\s*[A-Z][A-Za-z0-9_]*" contains=nimType

" ── Generics: Type[T] ─────────────────────────────────────────────────────
syntax match nimGeneric "\<[A-Z][A-Za-z0-9_]*\[" contains=nimType

" ── Attributes / annotations beginning with @ ────────────────────────────
syntax match nimAttribute "@\<[A-Za-z_][A-Za-z0-9_]*\>"

" ── Standard-library procedure call  foo(...) ────────────────────────────
syntax match nimFuncCall "\<[a-z_][A-Za-z0-9_]*\ze\s*("

" ── Module qualifier  module.name ─────────────────────────────────────────
syntax match nimModule "\<[A-Z][A-Za-z0-9_]*\ze\."

" ── Highlight links ───────────────────────────────────────────────────────
highlight default link nimConditional   Conditional
highlight default link nimRepeat        Repeat
highlight default link nimException     Exception
highlight default link nimLabel         Label
highlight default link nimDef           Keyword
highlight default link nimDefName       Function
highlight default link nimTypeDef       Structure
highlight default link nimMacro         Macro
highlight default link nimKeyword       Keyword
highlight default link nimBoolean       Boolean
highlight default link nimSpecial       Special
highlight default link nimType          Type
highlight default link nimPragmaKey     PreProc
highlight default link nimPragmaVal     String
highlight default link nimNumber        Number
highlight default link nimFloat         Float
highlight default link nimChar          Character
highlight default link nimString        String
highlight default link nimRawString     String
highlight default link nimCallString    String
highlight default link nimCallStringDelim Delimiter
highlight default link nimLongString    String
highlight default link nimFmtString     String
highlight default link nimFmtInterp     Special
highlight default link nimStringEscape  SpecialChar
highlight default link nimComment       Comment
highlight default link nimDocComment    SpecialComment
highlight default link nimBlockComment  Comment
highlight default link nimTodo          Todo
highlight default link nimOperator      Operator
highlight default link nimDelimiter     Delimiter
highlight default link nimTypeAnnotation Type
highlight default link nimGeneric       Type
highlight default link nimAttribute     PreProc
highlight default link nimFuncCall      Identifier
highlight default link nimModule        Identifier
highlight default link nimPragma        PreProc

let b:current_syntax = "nim"
