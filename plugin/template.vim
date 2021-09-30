let g:template_import = get(g:, 'template_import', {})
let g:template_header = get(g:, 'template_header', [])
let g:template_date = get(g:, 'template_date', [])

let s:fileType = {
            \  'cpp': {a, b -> s:cpp(a, b)},
            \  'hpp': {a, b -> s:hpp(a, b)},
            \ 'html': {a, b -> s:html(a, b)},
            \   'py': {a, b -> s:py(a, b)},
            \   'sh': {a, b -> s:sh(a, b)},
            \  'svg': {a, b -> s:svg(a, b)}
            \}

let s:types = {
            \ 'c\|h\|cc\|hh\|cpp\|hpp\|css\|php\|glsl':
                \ ['/*', '*/'],
            \ 'html\|htm\|xml':
                \ ["<!--", "-->"],
            \ 'el\|emacs':
                \ [';', ';'],
            \ 'f90\|f95\|f03\|f\|for':
                \ ['!', '!'],
            \ 'cs\|java\|js\|jsx\|ts\|tsx\|scss':
                \ ['//', '//'],
            \ 'ml\|mli\|mll\|mly':
                \ ['(*', '*)'],
            \ 'py':
                \ ['#', '#'],
            \ 'tex':
                \ ['%', '%'],
            \ 'vim\|\vimrc':
                \ ['"', '"'],
            \ }

fun! s:Template()
    let fileType = expand('%:e')
    let fileName = expand('%:t:r')
    let sw = exists('*shiftwidth') ? shiftwidth() : &l:shiftwidth
    let indent = (&l:expandtab || &l:tabstop !=# sw) ? repeat(' ', sw) : "\t"
    let Func = get(s:fileType, l:fileType, {a, b -> s:dead(a, b)})
    call Func(fileName, indent)
    if has_key(g:template_import, fileType)
        call s:import(fileName, g:template_import[fileType])
    endif
    if len(g:template_header) != 0
        call s:header(fileType)
    endif
endfun

fun! s:Check()
    if len(readfile(expand('%'), '', 1)) == 0
        call s:Template()
    endif
endfun

fun! s:import(fileName, list)
    call append(0, "")
    if type(a:list) == 3
        call s:revAppend(a:list)
    else
        let key = split(a:fileName, "_")[0]
        let key = "main\|test\|pch" =~ key ? key : "and"
        try
            call s:revAppend(a:list["or"])
        cat
        endt
        try
            call s:revAppend(a:list[key])
        cat
        endt
    endif
endfun

fun! s:revAppend(list)
    for i in range(len(a:list) - 1, 0, -1)
        call append(0, a:list[i])
    endfor
endfun

fun! s:header(fileType)
    for type in keys(s:types)
        if type =~ a:fileType
            let start = s:types[type][0]
            let end = s:types[type][1]
            for i in range(len(g:template_header) - 1, 0, -1)
                let line = g:template_header[i]
                let spaces = 80 - len(line)
                call append(0, start . ' ' . line . repeat(' ', spaces) . end)
            endfor
            if len(g:template_date) == 3
                let date = strftime(g:template_date[2])
                let spaces = 80 - len(date) - len(g:template_date[1]) + 1
                call append(g:template_date[0] - 1, start . g:template_date[1] . date . repeat(' ', spaces) . end)
            endif
            break
        endif
    endfor
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
    if a:fileName != "pch"
        call setline(1, "class " . a:fileName . " {")
        call append(1, [
                    \ a:indent . "private:",
                    \ repeat(a:indent, 2),
                    \ a:indent . "public:",
                    \ repeat(a:indent, 2),
                    \ "};"
                    \])
    endif
endfun

fun! s:html(fileName, indent)
    call setline(1, "<!DOCTYPE html>")
    call append(1, ['<html lang="en">', a:indent . '<head>',
        \repeat(a:indent, 2) . '<script src="" defer></script>',
        \repeat(a:indent, 2) . '<meta charset="utf-8">',
        \repeat(a:indent, 2) . '<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">',
        \repeat(a:indent, 2) . '<link href="" type="image/svg" rel="icon" sizes="16x16">',
        \repeat(a:indent, 2) . '<link href="" type="text/css" rel="stylesheet">',
        \repeat(a:indent, 2) . '<title></title>',
        \a:indent . '</head>',
        \a:indent . '<body>', repeat(a:indent,2) , a:indent . '</body>', '</html>'
        \])
endfun

fun! s:py(fileName, indent)
    let fileName = split(a:fileName, "_")
    if a:fileName == "main"
        call setline(1, "def main():")
        call append(1, [a:indent."pass", "", "if __name__ == \"__main__\":", a:indent."main()"])
    elseif "test" == fileName[0]
        call setline(1, "from " . fileName[1] . " import " . fileName[1])
        call append(1, ["import unittest", ""
                    \, "class TestList(unittest.TestCase):"
                    \, a:indent . "def setUp(self):"
                    \, repeat(a:indent, 2) . "self.cls = " . fileName[1] . "()", ""
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

fun! s:svg(fileName, indent)
    call setline(1, '<svg xmlns="http://www.w3.org/2000/svg" width="" height="" viewBox="">')
    call append(1, [a:indent . '<defs>',
                \ repeat(a:indent, 2) . '<style>',
                \ repeat(a:indent, 3),
                \ repeat(a:indent, 2) . '</style>',
                \ a:indent . '<defs>',
                \ a:indent,
                \ '<svg>'
                \])
endfun

autocmd BufNewFile * call s:Template()
autocmd BufRead * call s:Check()
