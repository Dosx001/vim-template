let g:template_import = get(g:, 'template_import', {})
let g:template_header = get(g:, 'template_header', 0)
let g:template_header_list = get(g:, 'template_header_list', [])
let g:template_date = get(g:, 'template_date', [])

let s:fileType = {
            \  'cpp': {a, b -> s:cpp(a, b)},
            \  'hpp': {a, b -> s:hpp(a, b)},
            \ 'html': {a, b -> s:html(a, b)},
            \   'py': {a, b -> s:py(a, b)},
            \   'sh': {a, b -> s:sh(a, b)}
            \}

let s:types = {
            \ 'c\|h\|cc\|hh\|cpp\|hpp\|php\|glsl':
                \ ['/*', '*/'],
            \ 'html\|htm\|xml':
                \ ["<!--", "-->"],
            \ 'el\|emacs':
                \ [';', ';'],
            \ 'f90\|f95\|f03\|f\|for':
                \ ['!', '!'],
            \ 'js\|ts':
                \ ['//', '//'],
            \ 'ml\|mli\|mll\|mly':
                \ ['(*', '*)'],
            \ 'tex':
                \ ['%', '%'],
            \ 'vim\|\vimrc':
                \ ['"', '"'],
            \ }

fun! s:Template()
    let l:fileType = expand('%:e')
    let l:fileName = expand('%:t:r')
    let sw = exists('*shiftwidth') ? shiftwidth() : &l:shiftwidth
    let l:indent = (&l:expandtab || &l:tabstop !=# sw) ? repeat(' ', sw) : "\t"
    let l:Func = get(s:fileType, l:fileType, {a, b -> s:dead(a, b)})
    call Func(l:fileName, l:indent)
    if has_key(g:template_import, l:fileType)
        call s:import(g:template_import[l:fileType])
    endif
    if g:template_header
        call s:header(l:fileType)
    endif
endfun

fun! s:Check()
    if len(readfile(expand('%'), '', 1)) == 0
        call s:Template()
    endif
endfun

fun! s:import(list)
    call append(0, "")
    for l:i in range(len(a:list) - 1, 0, -1)
        call append(0, a:list[l:i])
    endfor
endfun

fun! s:header(fileType)
    let l:start = '#'
    let l:end = '#'
    for type in keys(s:types)
        if a:fileType =~ type
            let l:start = s:types[type][0]
            let l:end = s:types[type][1]
            break
        endif
    endfor
    let l:spaces = 80
    for i in range(len(g:template_header_list) - 1, 0, -1)
        let line = g:template_header_list[i]
        let l:spaces = l:spaces - len(line)
        call append(0, l:start . ' ' . line . repeat(' ', l:spaces) . l:end)
        let l:spaces = 80
    endfor
    if len(g:template_date) != 0
        let date = strftime(g:template_date[2])
        let spaces = spaces - len(date) - len(g:template_date[1]) + 1
        call append(g:template_date[0] - 1, start . g:template_date[1] . date . repeat(' ', spaces) . end)
    endif
endfun

fun! s:dead(fileName, indent)
    return
endfun

fun! s:cpp(fileName, indent)
    if a:fileName == "main"
        call setline(1, "int main() {")
        call append(1, [a:indent, a:indent . "return 0;", "}"])
    else
        call setline(1, "#include \"" . a:fileName . ".hpp\"")
        call append(1, ["", a:fileName . "::" . a:fileName . "() {", a:indent, "}"])
    endif
endfun

fun! s:hpp(fileName, indent)
    call setline(1, "#pragma once")
    call append(1, ["", "class " . a:fileName . " {", a:indent . "private:",
                \ repeat(a:indent, 2),
                \ a:indent . "public:",
                \ repeat(a:indent, 2),
                \ "};"
                \])
endfun

fun! s:html(fileName, indent)
    call setline(1, "<!DOCTYPE html>")
    call append(1, ['<html lang="en">', a:indent . '<head>',
        \repeat(a:indent, 2) . '<script src="." defer></script>',
        \repeat(a:indent, 2) . '<meta charset="utf-8">',
        \repeat(a:indent, 2) . '<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">',
        \repeat(a:indent, 2) . '<link rel="icon" href="." type="image/svg" sizes="16x16">',
        \repeat(a:indent, 2) . '<link rel="stylesheet" type="text/css" href=".">',
        \repeat(a:indent, 2) . '<title></title>',
        \a:indent . '</head>',
        \a:indent . '<body>', repeat(a:indent,2) , a:indent . '</body>', '</html>'
        \])
endfun

fun! s:py(fileName, indent)
    let l:file = split(a:fileName, "_")
    if a:fileName == "main"
        call setline(1, "def main():")
        call append(1, [a:indent."pass", "", "if __name__ == \"__main__\":", a:indent."main()"])
    elseif "test" == l:file[0]
        call setline(1, "from " . l:file[1] . " import " . l:file[1])
        call append(1, ["import unittest", ""
                    \, "class TestList(unittest.TestCase):"
                    \, a:indent . "def setUp(self):"
                    \, repeat(a:indent, 2) . "self.cls = " . l:file[1] . "()", ""
                    \, a:indent . "def tearDown(self):"
                    \, repeat(a:indent, 2) . "pass", ""
                    \, a:indent . "def test(self):" , repeat(a:indent , 2) . "pass" , ""
                    \, a:indent . "def test(self):" , repeat(a:indent , 2) . "pass" , ""
                    \, a:indent . "def test(self):" , repeat(a:indent , 2) . "pass" , ""
                    \, 'if __name__ == "__main__":'
                    \, a:indent . "unittest.main()"
                    \])
    else
        call setline(1, "class " . a:fileName . ":")
        call append(1, [a:indent."def __init__(self):", repeat(a:indent,2) ."pass"])
    endif
endfun

fun! s:sh(fileName, indent)
    call append(0, "#!/bin/bash")
endfun

autocmd BufNewFile * call s:Template()
autocmd BufRead * call s:Check()
