#!/usr/bin/env python3

import sys
import argparse

from PIL import Image

ASCII_CHARS = ['#', '%', '@', 'S', '?', '*', ';', ':', ':', ',', '.']


class PicToArt:
    def __init__(self, args):
        self.args = args
        self.image = None

    def open_image(self):
        try:
            self.image = Image.open(self.args.image_filepath)
        except Exception as e:
            print(f"Unable to open image file {self.args.image_filepath}.")
            print(e)

    def _scale_image(self):
        (original_width, original_height) = self.image.size
        aspect_ratio = original_height/float(original_width)
        new_height = int(aspect_ratio * self.args.width_ascii)
        new_image = self.image.resize((self.args.width_ascii, new_height))
        return new_image

    def _pixel_to_char(self):
        pixels_in_image = list(self.image.getdata())
        m = max(pixels_in_image)
        pixels_to_chars = [
            ASCII_CHARS[
                int(((a/m) * (len(ASCII_CHARS))) - 1)
            ] for a in pixels_in_image
        ]
        return "".join(pixels_to_chars)

    def convert_image(self):
        self.image = self._scale_image()
        self.image = self.image.convert('L')

        pixels_to_chars = self._pixel_to_char()
        len_pixels_to_chars = len(pixels_to_chars)

        image_ascii = [pixels_to_chars[index: index + self.args.width_ascii]
                       for index in range(0, len_pixels_to_chars, self.args.width_ascii)]

        return "\n".join(image_ascii)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--image-filepath', type=str, required=True)
    parser.add_argument('-a', '--width-ascii', type=int,
                        default=100, required=False)
    return parser.parse_args()


if __name__ == '__main__':
    p = PicToArt(parse_args())
    p.open_image()
    print(p.convert_image())
