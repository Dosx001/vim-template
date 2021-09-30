# vim-template

## Table of Contents
* [Installation](#installation)
* [Supported File Types](#supported-file-types)
  * [Where's My Language](#wheres-my-language)
  * [Other Usage Cases](#other-usage-cases)
* [Tab vs Spaces](#tab-vs-spaces)
* [When does vim-template run?](#when-does-vim-template-run)
* [Examples](#examples)
  * [Python Example 1](#python-example-1)
  * [Python Example 2](#python-example-2)
  * [Python Example 3](#python-example-3)
  * [HTML Example](#html-example)
* [Configurations](#configurations)
  * [Automate Imports/Includes](#automate-importsincludes)
  * [Advance Automate Imports/Includes](#advance-automate-importsincludes)
  * [Add a Header](#add-a-header)
    * [Supported File Types: Header](#supported-file-types-header)
  * [Add the Date to Header](#add-the-date-to-header)

# Installation
## Vundle
```vim
Plugin 'Dosx001/vim-template'
```

## vim-plug
```vim
Plug 'Dosx001/vim-template'
```

# Supported File Types

* CMakeLists.txt
* cpp, hpp
* html
* js
* py
* sh
* ts
* svg
* vim

## Where's My Language
If your favorite language is not here, just create an issue or PR and submit a template. I won't
automatically accept PRs or resolve issues. I would like see feedback from the community for each
template. If there is official documentation for starter code, post it with your issue or PR.

## Other Usage Cases
Even if vim-template does not have any of your favorite languages, vim-template still offers great
value for you. Check out [Configurations](#configurations)!

# Tab vs Spaces
IT DON'T MATTER! vim-template will respect your indentation. Do you have differnt indentation for
different file types? IT DON'T MATTER! vim-template will respect them all.

# When does vim-template run?
If the file does not exist vim-template will run. If the file does exist vim-template will quickly
check if the file is COMPLETELY EMPTY and if true vim-template will run. If the file LOOKS EMPTY
but vim-template does not run just delete the file and recreate it.

What's an empty file? A file with a size of 0 bytes.

# Examples

## Python Example 1
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

## Python Example 2
```vim
vim pizza.py
```
Result
```python
class pizza:
    def __init__(self):
        pass
```

## Python Example 3
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

## HTML Example
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

# Configurations
## Automate Imports/Includes
vim-template can also automate your imports/includes for example set ```g:template_import``` inside your
.vimrc as such.
```vim
let g:template_import = {
            \ "py": ["import matplotlib.pyplot as plt", "import numpy as np", "import json"]
            \}
```
```g:template_import``` is a dictionary and each key must be a string. If you want to use
```g:template_import``` for a specific language you must use the file type of that language.
| Name | Key |
| --- | --- |
|C++ | cpp or hpp|
|Java | java|
|JavaScript | js|
|PHP | php|
|Python | py|
|TypeScript | ts|

And the value for each key must be an array of strings.
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
## Advance Automate Imports/Includes
As demonstrated in [Examples](#examples) vim-template can create different starter code based on
different conditions but when importing/including vim-template has a lack of discrepancy. This is
were advance settings come into play. Instead of setting each key to an array of string,
you can set each key to another dictionary.
| Key | Description |
| --- | --- |
| main | Files named main |
| test | Files names starting with "test_" |
| pch | This is a unique key for C++ precompiled header files (More unique keys might be added for different languages) |
| or | For files that do not meet the previous descriptions |
| and | Every single file no matter what |

Example
```vim
let g:template_import = {
            \ "cpp": {
                \ "main" : ['#include "MyClass.hpp"'],
            \ },
            \ "hpp": {
                \ "test": ['#include "MyClass.hpp"'],
                \ "pch": ['#pragma once', '#include <iostream>', '#include <string>', '#include <vector>'],
                \ "or": ['#pragma once', '#include "pch.hpp"'],
                \ "and": ['// I <3 vim-template']
            \ }
            \}
```
```vim
vim main.cpp MyClass.hpp test_MyClass.hpp pch.hpp -p
```
Results

vim.cpp
```c++
#include "MyClass.hpp"

int main() {
    
    return 0;
}
```
MyClass.hpp
```c++
#pragma once
#include "pch.hpp"
// I <3 vim-template

class MyClass {
    private:
        
    public:
        
};
```
test_MyClass.hpp
```c++
#include "MyClass.hpp"
// I <3 vim-template

class test_MyClass {
    private:
        
    public:
        
};
```
pch.hpp
```c++
#pragma once
#include <iostream>
#include <string>
#include <vector>
// I <3 vim-template
```
## Add a Header
If you want vim-template add to add a header set  ```g:template_header```, inside your .vimrc,
equal to an array of strings.
```vim
let g:template_header = [
            \ "   Name: Andres Rodriguez",
            \ "Purpose:",
            \ "  Notes:",
            \ ""
            \ ]
```
Result
```python
#    Name: Andres Rodriguez                                                       #
# Purpose:                                                                        #
#   Notes:                                                                        #
#                                                                                 #
def main():
    pass

if __name__ == "__main__":
    main()
```
## Supported File Types: Header
c, cc, cpp, cs, css, el, emacs, f, f03, f90, f95, for, glsl, h, hh, hpp, htm, html,
java, js, jsx, ml, mli, mll, mly, php, py, scss, tex, ts, tsx, vim, vimrc, xml

Make an issue or PR to add more!
## Add the Date to Header
If you want vim-template to add the date inside your header use ```g:template_date```.
```g:template_date``` is an array. The first value is an integer, set it to which line you want the date
section to appear on. The second value is a string, set it on how the want the date section to be
formated. The third and last value is a string, set it on how you want the date to be formated.
```vim
let g:template_header = [
            \ "   Name: Andres Rodriguez",
            \ "Purpose:",
            \ "  Notes:",
            \ ""
            \ ]
let g:template_date = [2, "    Date: ", "%Y-%m-%d %H:%M:%S"]
```
If you need help with the date formatting, check out this
<a href="https://www.journaldev.com/23365/python-string-to-datetime-strptime">link</a>

Result
```python
1  #    Name: Andres Rodriguez                                                       #
2  #    Date: 2021-09-28 19:03:42                                                    #
3  # Purpose:                                                                        #
4  #   Notes:                                                                        #
5  #                                                                                 #
6  def main():
7      pass
8
9  if __name__ == "__main__":
10     main()
```
