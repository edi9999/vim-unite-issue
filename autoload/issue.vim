
" vim-unite-issue - Issue tracker and timer for Vim
" Maintainer: Rafael Bodill <justrafi at gmail dot com>
" Version:    20141008
"-------------------------------------------------

let s:save_cpo = &cpo
set cpo&vim

" Verifying dependencies " {{{
if ! g:loaded_unite
	finish
endif

if ! executable('curl')
	call unite#print_error('unite-issue requires the `curl` command')
endif
" }}}

" Public methods
" --------------
function! issue#get_path(dict, path) " {{{
	" Gets a path from a dictionary, e.g. 'fields.foo.bar'
	"
	let key_parts = split(a:path, '\.')
	let found = ''
	let value = a:dict
	while len(key_parts) > 0 && found == ''
		let key_part = remove(key_parts, 0)
		if type(get(value, key_part)) != 4
			let found = get(value, key_part)
		else
			let value = get(value, key_part)
		endif
	endwhile

	return found ? found : ''
endfunction

" }}}
function! issue#highlight_general() " {{{
	" Defines general issue list highlights
	"
	syntax match uniteSource__Issue_Properties /.*|\s/
				\ contained containedin=uniteSource__Issue
	highlight default link uniteSource__Issue_Properties Function

	" Within properties, match a non-word before a semicolon
	syntax match uniteSource__Issue_Count /[^a-z ]\+\ze:/
				\ contained containedin=uniteSource__Issue_Properties
	highlight default link uniteSource__Issue_Count Statement

	" Within properties, match a word after a semicolon
	syntax match uniteSource__Issue_Status /\:[a-zA-Z\-\_]\+\>/
				\ contained containedin=uniteSource__Issue_Properties
	highlight default link uniteSource__Issue_Status PreProc

	" Outside of properties,
	" match everything between brackets towards end of string
	syntax match uniteSource__Issue_Labels /\[.\+\]\s*$/
				\ contained containedin=uniteSource__Issue
	highlight default link uniteSource__Issue_Labels Comment
endfunction
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set ts=2 sw=2 tw=80 noet :