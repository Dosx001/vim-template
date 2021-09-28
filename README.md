# vim-template

## Table of Contents
* [Installation](#installation)
* [File Extension Supported](#file-extension-supported)
  * [Where's My Language](#wheres-my-language)
  * [Other Usage Cases](#other-usage-cases)
* [Tab vs Spaces](#tab-vs-spaces)
* [When does vim-template run?](#when-does-vim-template-run)
* [Examples](#examples)
  * [Python Example 1](#python-example-1)
  * [Python Example 2](#python-example-2)
  * [Python Example 2](#python-example-3)
  * [HTML Example](#html-example)
* [Configuration](#configuration)

## Installation
### Vundle
```vim
Plugin 'Dosx001/vim-template'
```

### vim-plug
```vim
Plug 'Dosx001/vim-template'
```

## File Extension Supported

* .cpp, .hpp
* .html
* .py
* .sh

### Where's My Language
If your favorite language is not here, just create an issue or PR and submit a template. I won't
automatically accept PRs or resolve issues. I would like see feedback from the community for each
template. If there is official documentation for starter code, post it with your issue or PR.

### Other Usage Cases
Even if vim-template does not have any of your favorite languages, vim-template still offers great
vaule for you. Check out [Configuration](#configuration)

## Tab vs Spaces
IT DON'T MATTER! vim-template will respect your indentation. Do you have differnt indentation for
different file types? IT DON'T MATTER! vim-template will respect them all.

## When does vim-template run?
If the file does not exist vim-template will run. If the file does exist vim-template will quickly
check if the file is COMPLETELY EMPTY and if true vim-template will run. If the file LOOKS EMPTY
but vim-template does not run just delete the file and recreate it.

What's an empty file? A file with a size of 0 bytes.

## Examples

### Python Example 1
```vim
vim main.py
```
Result
```python
def main():
    pass

if __name__ == "__main__":
    main()
```

### Python Example 2
```vim
vim pizza.py
```
Result
```python
class pizza:
    def __init__(self):
        pass
```

### Python Example 3
```vim
vim test_rocket.py
```
Result
```python
from rocket import rocket
import unittest

class TestList(unittest.TestCase):
    def setUp(self):
        self.cls = rocket()

    def tearDown(self):
        pass

    def test(self):
        pass

    def test(self):
        pass

    def test(self):
        pass

if __name__ == "__main__":
    unittest.main()
```

### HTML Example
```vim
vim index.html
```
Result
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <script src="." defer></script>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="icon" href="." type="image/svg" sizes="16x16">
    <link rel="stylesheet" type="text/css" href=".">
    <title></title>
  </head>
  <body>
    
  </body>
</html>
```

## Configuration
vim-template can also automate your imports for example set ```g:template_import``` inside your
.vimrc as such.
```vim
let g:template_import = {
            \ "py": ["import matplotlib.pyplot as plt", "import numpy as np", "import json"]
            \}
```
```vim
vim main.py
```
Result
```python
import matplotlib.pyplot as plt
import numpy as np
import json

def main():
    pass

if __name__ == "__main__":
    main()
```
