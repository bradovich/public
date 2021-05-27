import matplotlib.pyplot as plt
import numpy as np
from math import sqrt


def mandelbrot(real_num, im_num, maxiter):
    c = complex(real_num, im_num)
    z = complex(0, 0)
    it = 0
    while (abs(z) < 2) & (it <= maxiter):
        it += 1
        z = z*z + c

    return it


px = 1000000

# real and imaginary range to create
x1 = -2
x2 = 1
y1 = -1
y2 = 1

pix_W = int(sqrt(px) * (abs(x2 - x1) / (abs(x2 - x1) + abs(y2 - y1))))
pix_H = int(sqrt(px) * (abs(y2 - y1) / (abs(x2 - x1) + abs(y2 - y1))))


my_grid = np.zeros([pix_W, pix_H])
for row_index, re in enumerate(np.linspace(x1, x2, num=pix_W)):
    for col_index, im in enumerate(np.linspace(y1, y2, num=pix_H)):
        my_grid[row_index, col_index] = mandelbrot(re, im, 50)

plt.figure(dpi=100)
plt.imshow(my_grid.T, cmap="Spectral", interpolation="bilinear", extent=[x1, x2, y1, y2])
plt.xlabel("Real")
plt.ylabel("Imaginary")
plt.show()
