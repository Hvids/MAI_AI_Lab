import json
file = 'names_file'
path_files = './files_c++/'

names_file__write_json = 'names_file.json'

names = []
with open(file,'r') as f:
    for line in f:
        names.append(line[:-1])

with open(names_file__write_json,'w') as write_file:
    json.dump(names,write_file)


name_all_text = 'all_text.txt'

with open(name_all_text,'w') as write:
    for name in names:
        with open(path_files + name) as file:
            text = file.read()

            write.write(text)
