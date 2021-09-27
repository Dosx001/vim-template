fun! Template()
    let l:fileType = expand('%:e')
    let l:fileName = expand('%:t:r')
    let sw = exists('*shiftwidth') ? shiftwidth() : &l:shiftwidth
    let l:indent = (&l:expandtab || &l:tabstop !=# sw) ? repeat(' ', sw) : "\t"
    let l:langs = {
                \  'cpp': {a, b -> s:cpp(a, b)},
                \  'hpp': {a, b -> s:hpp(a, b)},
                \ 'html': {a, b -> s:html(a, b)},
                \   'py': {a, b -> s:py(a, b)},
                \   'sh': {a, b -> s:sh(a, b)}
                \}
    let l:Func = get(langs, l:fileType, {a, b -> s:dead(a, b)})
    call Func(l:fileName, l:indent)
endfun

fun! s:dead(fileName, indent)
    return
endfun

fun! s:cpp(fileName, indent)
    if a:fileName == "main"
        call append(1, ["", "int main() {", a:indent, a:indent."return 0;", "}"])
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
    if a:fileName == "main"
        call setline(1, "def main():")
        call append(1, [a:indent."pass", "", "if __name__ == \"__main__\":", a:indent."main()"])
    else
        call setline(1, "class " . a:fileName . ":")
        call append(1, [a:indent."def __init__(self):", repeat(a:indent,2) ."pass"])
    endif
endfun

fun! s:sh(fileName, indent)
    call append(0, "#!/bin/bash")
endfun

autocmd BufNewFile * call Template()
