from ImageSpliter import Spliter, Image

PATH_TRAINING = './images/training_set'
PATH_TEST = './images/test_set'

image_art_name = './images/artyom.jpg'
image_den_name = './images/denis.jpg'
image_hvids_name = './images/danila.jpg'

image_hvids = Image(image_hvids_name)
labels_hvids = ['Э', 'Э', 'Ю', 'Ю', 'Я', 'Я']
split_params = {
    'start_row': 0,
    'start_col': 1,
    'window': 59,
    'end_row': 350,
    'end_col': 3411,
}
# print(image_hvids.image.shape)
image_hvids.set_split_params(**split_params)

image_den = Image(image_den_name)
labels_den = ['Э', 'Э', 'Ю', 'Ю', 'Я', 'Я']
split_params = {
    'start_row': 0,
    'start_col': 5,
    'window': 59,

}
# print(image_den.image.shape)
image_den.set_split_params(**split_params)

image_art = Image(image_art_name)
labels_art = ['Э', 'Э', 'Ю', 'Ю', 'Я', 'Я']
split_params = {
    'start_row': 9,
    'start_col': 0,
    'window': 59,
    'end_row': 363,
    'end_col': 2770,
}

# print(image_art.image.shape)
image_art.set_split_params(**split_params)

IMAGE_NUMBER = 0

spliter = Spliter(PATH_TRAINING, IMAGE_NUMBER)
IMAGE_NUMBER = spliter.split(image_hvids, labels_hvids)
IMAGE_NUMBER += 1

spliter = Spliter(PATH_TRAINING, IMAGE_NUMBER)
IMAGE_NUMBER = spliter.split(image_den, labels_den)

IMAGE_NUMBER = 0
spliter = Spliter(PATH_TEST, IMAGE_NUMBER)
spliter.split(image_art, labels_art)
