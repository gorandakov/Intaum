echo $'    class funit : module12 {\n' core_forfu.v >core_forfu.cpp
grep '[ ]*reg [ ]*\(\[[][0-9`_:A-Za-z+-]*\]\)[ ]*.*;' -A 0 -B 0 -o -h --no-group-separator <core_forfu.v | sed 's/\([ ]*\)reg\( [ ]*\)\(\[[][0-9`_:A-Za-z+-]*\]\)[ ]*\(.*\);/\1regwire\2\4\3;/g' >>core_forfu.cpp
grep '[ ]*wire [ ]*\(\[[][0-9`_:A-Za-z+-]*\]\)[ ]*.*;' -A 0 -B 0 -o -h --no-group-separator <core_forfu.v | sed 's/\([ ]*\)wire\( [ ]*\)\(\[[][0-9`_:A-Za-z+-]*\]\)[ ]*\(.*\);/\1contwire\2\4\3;/g' >>core_forfu.cpp

