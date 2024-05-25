from PIL import Image, ImageOps
import numpy as np
import matplotlib.pyplot as plt

# Load and process the image
img = Image.open('image.png')
img = img.resize((750, 800))
img = ImageOps.grayscale(img)  # Convert to grayscale

# Convert image to numpy array
np_img = np.array(img)

# Invert colors and binarize
np_img = ~np_img
np_img[np_img > 0] = 1

# Save the numpy array to .npy file
np.save('image.npy', np_img)


