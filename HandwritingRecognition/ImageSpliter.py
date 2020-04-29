import cv2
import numpy as np


class Image:
    def __init__(self, file):
        self.image = cv2.imread(file, 1)
        self.height = self.image.shape[0]
        self.width = self.image.shape[1]
        self.channels = self.image.shape[2]

        # default params
        self.start_row = 0
        self.end_row = self.height
        self.start_col = 0
        self.end_col = self.width
        self.window = 50

    def set_split_params(self, start_row, start_col, window, end_col=None, end_row=None):
        self.start_col = start_col
        self.start_row = start_row
        self.end_col = end_col if end_col is not None else self.end_col
        self.end_row = end_row if end_row is not None else self.end_row
        self.window = window

    # return range of start pixel of pictures in height
    @property
    def rows(self):
        rang = np.arange(self.start_row, self.end_row, self.window)
        return rang

    # return range of start pixel of pictures in width
    @property
    def cols(self):
        rang = np.arange(self.start_col, self.end_col, self.window)
        return rang


    # count of crop images
    @property
    def count_images(self):
        return (self.rows.shape[0] - 1) * (self.cols.shape[0] - 1)

    # get crop image
    def get_window(self, row_start, row_end, col_start, col_end):
        return self.image[row_start:row_end, col_start:col_end, :]


class Spliter:
    def __init__(self, path_to_save, number):
        self.path_to_save = path_to_save
        self.number = number
        self.rows = None
        self.cols = None
        self.count_of_images = None
        self.step = None
        self.image = None
        self.labels = None

    def split(self, image, labels):
        print('Spliting ---- =>', end='')
        self.image = image
        self.rows = image.rows
        self.cols = image.cols
        self.count_of_images = image.count_images
        self.step = 0
        self.labels = labels
        self.__split()
        print()
        return self.number

    def __split(self):
        for i, r_pixel in enumerate(self.rows[:-1]):
            for c_pixel in self.cols[:-1]:
                self.number += 1
                self.step += 1
                image = self.image.get_window(r_pixel, r_pixel + self.image.window,
                                              c_pixel, c_pixel + self.image.window)
                self.save_image(image, self.labels[i])
                self.print_loader()
            self.number += 1
            self.step += 1
            image = self.image.get_window(r_pixel, r_pixel + self.image.window,
                                          self.cols[-1], self.image.end_col)
            self.save_image(image, self.labels[i])
            self.print_loader()
        if self.image.end_row - self.rows[-1] > self.image.window // 2:
            for c_pixel in self.cols[:-1]:
                self.number += 1
                self.step += 1
                image = self.image.get_window(self.rows[-1], self.image.end_row,
                                              c_pixel, c_pixel + self.image.window)
                self.save_image(image, self.labels[i])
                self.print_loader()
            self.number += 1
            self.step += 1
            image = self.image.get_window(self.rows[-1], self.image.end_row,
                                          self.cols[-1], self.image.end_col)
            self.save_image(image, self.labels[i])
            self.print_loader()


    def save_image(self, image, label):
        path_to_save = f'{self.path_to_save}/{label}/{label}_{self.number}.jpg'
        cv2.imwrite(path_to_save, image)

    def print_loader(self):
        val = self.step % 10 == 0
        if val:
            print('\b', end='')
            print(f'=>', end='')
