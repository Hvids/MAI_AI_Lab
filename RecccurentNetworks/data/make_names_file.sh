#!bin/bash
echo  'Make names file c++'

NAME_OUT="names_file"
PATH_FIND="files_c++/"
PYTHON_SCRIPT="names_file.py"
ls $PATH_FIND > $NAME_OUT
python3 $PYTHON_SCRIPT

exit 0
