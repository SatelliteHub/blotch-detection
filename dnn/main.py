import os
import sys
import numpy as np
import cv2
import pandas as pd

import pydot

import torch
import torch.nn as nn
import torch.nn.functional as F

import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
# %matplotlib inline

import tensorflow as tf
import keras
from keras import layers
from keras import callbacks
from keras.layers import Dense
import tensorflow_datasets as tfds
import matplotlib.pyplot as plt
import numpy as np

# from keras import datasets
from keras.layers import (Dense, Flatten, Dropout, Activation, BatchNormalization,
                          Input, Conv2D, MaxPool2D, Lambda, Conv2DTranspose,
                          concatenate, UpSampling2D, PReLU, LeakyReLU, Add, Cropping2D)

from keras.models import Model

from IPython.display import clear_output

import sklearn as skl
from sklearn import datasets, linear_model, model_selection
from sklearn.model_selection import train_test_split

from keras.utils import plot_model
from datetime import datetime

# From local Python file...
from utils import PlotLossAccuracy, display_learning_curves
from unet import unet_model


# Initialize and store the frames
frames = []
for i in range(1, 10): #352
    frame_path = f'/Users/meteore929/Documents/MAI Research/Videos/Carrier/carrier_numbered/carrier{i:04d}.tif'
    frame = cv2.imread(frame_path)
    if frame is None:
        print(f"Error: Unable to read image {frame_path}")
        continue
    frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    frames.append(frame)

gt_frames = []
for i in range(1, 10):
    gt_frame_path = f'/Users/meteore929/Documents/MAI Research/Videos/Carrier/GroundTruth/gt_carrier{i:04d}.tiff'
    gt_frame = cv2.imread(gt_frame_path, cv2.IMREAD_GRAYSCALE)
    gt_frame = np.expand_dims(gt_frame, axis=-1)
    gt_frames.append(gt_frame)

print(frames[0].shape)
print(gt_frames[0].shape)



X_combined = np.array(frames)
y_combined = np.array(gt_frames)
X = X_combined.astype('float32') / 255
y = y_combined.astype('float32') / 255

# Split the data into training and temporary sets (80:20)
X_train, X_temp, y_train, y_temp = train_test_split(X, y, test_size=0.2)

# Split the temporary set into validation and test sets (50:50)
X_validation, X_test, y_validation, y_test = train_test_split(X_temp, y_temp, test_size=0.5)

# Create an instance of our callback functions class, to plot our loss function and accuracy with each epoch.
pltCallBack = PlotLossAccuracy()

print('X_train', X_train.shape)
print('Y_train', y_train.shape)
print('X_validation', X_validation.shape)
print('Y_validation', y_validation.shape)
print('X_test', X_test.shape)
print('Y_test', y_test.shape)



# Build the U-Net model
model = unet_model()

# Select an optimizer
opt = keras.optimizers.Adam()

# Compile the model
model.compile(optimizer=opt,
              loss='binary_crossentropy',
              metrics=['accuracy'])

# Display the model summary
model.summary()

if (model.count_params() > 3000000):
    raise Exception("Your model is unecessarily complex, scale down!")

# Visualization of the U-Net architecture
# plot_model(model, show_shapes=True, to_file='unet_vis.png')

num_epochs = 4
pltCallBack = PlotLossAccuracy()

# Run the trianing and store the training history.
print("Model fitting on training data...")
time_start = datetime.now()
model.fit(X_train, y_train,
          batch_size=1,
          epochs=num_epochs,
          validation_data=(X_validation, y_validation),
          callbacks=[pltCallBack])

time_end = datetime.now()
print(f'Duration: {time_end - time_start}')
