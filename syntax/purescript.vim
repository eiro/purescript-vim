" syntax highlighting for purescript
"
" Heavily modified version of the purescript syntax
" highlighter to support purescript.
"
" author: raichoo (raichoo@googlemail.com)

if exists("b:current_syntax")
  finish
endif

" Type
syn match purescriptType "\<[A-Z]\w*\>"
syn match purescriptTypeVar "\<[_a-z]\(\w\|\'\)*\>"
syn region purescriptTypeExport matchgroup=purescriptType start="\<[A-Z]\(\S\&[^,.]\)*\>("rs=e-1 matchgroup=purescriptBlockDelimiter end=")" contained extend
  \ contains=purescriptConstructor,purescriptBlockDelimiter

" Constructor
syn match purescriptConstructor "\<[A-Z]\w*\>" contained
  \ containedin=purescriptFunctionBody
syn region purescriptConstructorDecl matchgroup=purescriptConstructor start="\<[A-Z]\w*\>" end="\(|\|$\)"me=e-1,re=e-1 contained
  \ containedin=purescriptData,purescriptNewtype
  \ contains=purescriptType,purescriptTypeVar,purescriptDelimiter,purescriptBlockDelimiter,purescriptOperatorType,purescriptOperatorTypeSig,purescriptLineComment,purescriptBlockComment

" Function
syn region purescriptFunctionBody excludenl start="^\z(\s*\)[_a-z]\(\w\|\'\)*\([^=]\{-}=\|\_.\{-}|\)" end="^\z1\?\S"me=s-1,re=s-1 fold transparent keepend extend
syn match purescriptFunctionDecl "^\s*\(foreign import\s\+\)\?[_a-z]\(\w\|\'\)*\n\?\s*\(::\|∷\)"
  \ contains=purescriptImportKeyword,purescriptFunction,purescriptOperatorType
syn match purescriptFunction "\<[_a-z]\(\w\|\'\)*\>" contained
syn match purescriptFunction "(\(\W\&[^(),\"]\)\+)" contained extend
syn match purescriptBacktick "`[_A-Za-z][A-Za-z0-9_]*`"
syn keyword purescriptForall forall
syn match purescriptForall "∀"

" Module
syn match purescriptModuleName "\(\w\+\.\?\)*" contained excludenl
syn match purescriptModuleKeyword "\<module\>"
syn match purescriptModule "^module\>\s\+\<\(\w\+\.\?\)*\>"
  \ contains=purescriptModuleKeyword,purescriptModuleName
  \ nextgroup=purescriptModuleParams skipwhite skipnl skipempty
syn region purescriptModuleParams start="(" end=")" fold contained keepend
  \ contains=purescriptBlockComment,purescriptLineComment,purescriptDelimiter,purescriptType,purescriptTypeExport,purescriptFunction,purescriptStructure,purescriptModuleKeyword
  \ nextgroup=purescriptImportParams skipwhite

" Import
syn match purescriptImportKeyword "\<\(foreign\|import\|qualified\)\>"
syn match purescriptForeignImport "\<\(foreign\s\+import\)\>"
  \ contains=purescriptImportKeyword
  \ nextgroup=purescriptFunction,purescriptStructure
syn keyword purescriptAsKeyword as contained
syn keyword purescriptHidingKeyword hiding contained
syn match purescriptImport "\<import\>\s\+\(qualified\s\+\)\?\<\(\w\+\.\?\)*\>"
  \ contains=purescriptImportKeyword,purescriptModuleName
  \ nextgroup=purescriptModuleParams,purescriptImportParams skipwhite
syn match purescriptImportParams "as\s\+\(\w\+\)" contained
  \ contains=purescriptModuleName,purescriptAsKeyword
  \ nextgroup=purescriptModuleParams,purescriptImportParams skipwhite
syn match purescriptImportParams "hiding" contained
  \ contains=purescriptHidingKeyword
  \ nextgroup=purescriptModuleParams,purescriptImportParams skipwhite

" Keywords
syn keyword purescriptConditional if then else
syn keyword purescriptStatement do case of let in
syn keyword purescriptWhere where
" syn keyword purescriptStructure data newtype type class
syn match purescriptStructure "\<\(data\|newtype\|type\|class\)\>"
  \ nextgroup=purescriptType skipwhite
syn keyword purescriptStructure derive
syn keyword purescriptStructure instance
  \ nextgroup=purescriptFunction skipwhite

" Infix
syn match purescriptInfixKeyword "\<\(infix\|infixl\|infixr\)\>"
syn match purescriptInfix "^\(infix\|infixl\|infixr\)\>\s\+\([0-9]\+\)\s\+\(type\s\+\)\?\(\S\+\)\s\+as\>"
  \ contains=purescriptInfixKeyword,purescriptNumber,purescriptAsKeyword,purescriptConstructor,purescriptStructure,purescriptFunction,purescriptBlockComment
  \ nextgroup=purescriptFunction,purescriptOperator,purescriptLineComment,purescriptBlockComment

" Values
syn match purescriptIdentifier "\<[_a-z]\(\w\|\'\)*\>" contained
  \ containedin=purescriptFunctionBody,purescriptRow
syn keyword purescriptBoolean true false
syn match purescriptNumber "0[xX][0-9a-fA-F]\+\|0[oO][0-7]\|[0-9]\+"
syn match purescriptFloat "[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\="

" Operators
syn match purescriptOperator "\([-!#$%&\*\+/<=>\?@\\^|~:]\|\<_\>\)"
syn match purescriptOperatorType "\(::\|∷\)"
  \ nextgroup=purescriptForall,purescriptType skipwhite skipnl skipempty
syn match purescriptOperatorTypeSig "\(->\|<-\|=>\|<=\|::\|[∷∀→←⇒⇐]\)" contained
  \ nextgroup=purescriptType skipwhite skipnl skipempty
syn match purescriptOperatorFunction "\(->\|<-\|[→←]\)" contained

" Delimiters
syn match purescriptDelimiter "[,;|.]"
syn match purescriptBlockDelimiter "[()[\]{}]"

" Type definition
syn region purescriptData start="^data\s\+\([A-Z]\w*\)" end="^\S"me=s-1,re=s-1 transparent
syn match purescriptDataStart "^data\s\+\([A-Z]\w*\)" contained
  \ containedin=purescriptData
  \ contains=purescriptStructure,purescriptType,purescriptTypeVar

syn region purescriptNewtype start="^newtype\s\+\([A-Z]\w*\)" end="^\S"me=s-1,re=s-1 transparent
syn match purescriptNewtypeStart "^newtype\s\+\([A-Z]\w*\)" contained
  \ containedin=purescriptNewtype
  \ contains=purescriptStructure,purescriptType,purescriptTypeVar

syn region purescriptType start="^type\s\+\([A-Z]\w*\)" end="^\S"me=s-1,re=s-1 transparent
syn match purescriptTypeStart "^type\s\+\([A-Z]\w*\)" contained
  \ containedin=purescriptType
  \ contains=purescriptStructure,purescriptType,purescriptTypeVar

" String
syn match purescriptChar "'[^'\\]'\|'\\.'\|'\\u[0-9a-fA-F]\{4}'"
syn region purescriptString start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region purescriptMultilineString start=+"""+ end=+"""+ fold

" Comment
syn match purescriptLineComment "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
syn region purescriptBlockComment start="{-" end="-}" fold
  \ contains=purescriptBlockComment

" highlight links
highlight def link purescriptModuleKeyword purescriptKeyword
highlight def link purescriptModuleName Include
highlight def link purescriptModuleParams purescriptDelimiter
highlight def link purescriptImportKeyword purescriptKeyword
highlight def link purescriptAsKeyword purescriptKeyword
highlight def link purescriptHidingKeyword purescriptKeyword

highlight def link purescriptConditional Conditional
highlight def link purescriptWhere purescriptKeyword
highlight def link purescriptInfixKeyword purescriptKeyword

highlight def link purescriptBoolean Boolean
highlight def link purescriptNumber Number
highlight def link purescriptFloat Float

highlight def link purescriptBlockDelimiter purescriptDelimiter
highlight def link purescriptDelimiter Delimiter

highlight def link purescriptOperatorTypeSig purescriptOperatorType
highlight def link purescriptOperatorFunction purescriptOperatorType
highlight def link purescriptOperatorType purescriptOperator

highlight def link purescriptConstructorDecl purescriptConstructor
highlight def link purescriptConstructor purescriptFunction

highlight def link purescriptTypeVar Identifier
highlight def link purescriptForall purescriptStatement

highlight def link purescriptChar String
highlight def link purescriptBacktick purescriptOperator
highlight def link purescriptString String
highlight def link purescriptMultilineString String

highlight def link purescriptLineComment purescriptComment
highlight def link purescriptBlockComment purescriptComment

" purescript general highlights
highlight def link purescriptStructure purescriptKeyword
highlight def link purescriptKeyword Keyword
highlight def link purescriptStatement Statement
highlight def link purescriptOperator Operator
highlight def link purescriptFunction Function
highlight def link purescriptType Type
highlight def link purescriptComment Comment

let b:current_syntax = "purescript"
