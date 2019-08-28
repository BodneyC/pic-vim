Pic-Vim
=======

Pic-Vim is a short plugin which leverages the Python Imaging [Library](https://pillow.readthedocs.io/en/stable/) to generate ascii art of image files you open.

## What is this?

On the odd occasion that I accidentally open an image file in Vim, I am confronted with the contents of the file, obviously. But I always want to know what the actual image is and with minimal effort, and because my file naming scheme is hot garbage and I usually open the image file due to a globbing misfortune, I usually have no idea.

So I figured split the window, literal contents on the left, and some indicator of the image's visual contents on the right, so, here's my face (kind of):

![screen-shot](media/screen-shot.png)

## Why is this?

Well, there isn't one really. If your terminal doesn't support images (like most), then open it with a media viewer... like normal people.

Either way, it seemed like a neat idea.

## How?

Everything you need to know is documented in the help file (`./doc/pic-vim.txt`).

    :h pic-vim

## Dependencies

 - [Python 3](https://www.python.org/download/releases/3.0/)
