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
        echo "C"
    elseif l:fileType == "html"
        echo "H"
    endif
endfunction

autocmd BufNewFile * call Template()
