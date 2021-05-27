import matplotlib.pyplot as plt
import numpy as np


def mandelbrot(real_num, im_num, maxiter):
    c = complex(real_num, im_num)
    z = complex(0, 0)
    it = 0
    while (abs(z) < 2) & (it <= maxiter):
        it += 1
        z = z*z + c

    return it


pix_W = 6000
pix_H = 4000

my_grid = np.zeros([pix_W, pix_H])
for row_index, re in enumerate(np.linspace(-2, 1, num=pix_W)):
    for col_index, im in enumerate(np.linspace(-1, 1, num=pix_H)):
        my_grid[row_index, col_index] = mandelbrot(re, im, 50)

plt.figure(dpi=100)
plt.imshow(my_grid.T, cmap="coolwarm", interpolation="bilinear", extent=[-2, 1, -1, 1])
plt.xlabel("Real")
plt.ylabel("Imaginary")
plt.show()
