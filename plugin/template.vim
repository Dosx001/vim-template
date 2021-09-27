function Template()
    let l:fileType = expand('%:e')
    let l:fileName = expand('%:t:r')
    let sw = exists('*shiftwidth') ? shiftwidth() : &l:shiftwidth
    let l:indent = (&l:expandtab || &l:tabstop !=# sw) ? repeat(' ', sw) : "\t"
    if l:fileType == "py"
        if l:fileName == "main"
            call setline(1, "def main():")
            call append(1, [indent."pass", "", "if __name__ == \"__main__\":", indent."main()"])
        else
            call setline(1, "class " . l:fileName . ":")
            call append(1, [indent."def __init__(self):", indent.indent."pass"])
        endif
    elseif l:fileType == "cpp"
        if l:fileName == "main"
            call append(1, ["", "int main() {", indent, indent."return 0;", "}"])
        else
            call setline(1, "#include \"" . l:fileName . ".hpp\"")
            call append(1, ["", l:fileName . "::" . l:fileName . "() {", indent, "}"])
        endif
    elseif l:fileType == "html"
        call setline(1, "<!DOCTYPE html>")
        call append(1, ['<html lang="en">', indent . '<head>',
            \repeat(indent, 2) . '<meta charset="utf-8">',
            \repeat(indent, 2) . '<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">',
            \repeat(indent, 2) . '<link rel="icon" href="." type="image/svg" sizes="16x16">',
            \repeat(indent, 2) . '<link rel="stylesheet" type="text/css" href=".">',
            \repeat(indent, 2) . '<title></title>',
            \indent . '</head>',
            \indent . '<body>', repeat(indent,2) , indent . '</body>', '</html>'
            \])
    endif
endfunction

autocmd BufNewFile * call Template()
