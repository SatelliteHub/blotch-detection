import os
import sys
import numpy as np
import cv2
import pandas as pd

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


# Define some useful functions
class PlotLossAccuracy(keras.callbacks.Callback):
    def on_train_begin(self, logs={}):
        self.i = 0
        self.x = []
        self.acc = []
        self.losses = []
        self.val_losses = []
        self.val_acc = []
        self.logs = []

    def on_epoch_end(self, epoch, logs={}):

        self.logs.append(logs)
        self.x.append(int(self.i))
        self.losses.append(logs.get('loss'))
        self.val_losses.append(logs.get('val_loss'))
        self.acc.append(logs.get('accuracy'))
        self.val_acc.append(logs.get('val_accuracy'))

        self.i += 1

        clear_output(wait=True)
        plt.figure(figsize=(16, 6))
        plt.plot([1, 2])
        plt.subplot(121)
        plt.plot(self.x, self.losses, label="train loss")
        plt.plot(self.x, self.val_losses, label="validation loss")
        plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
        plt.ylabel('loss')
        plt.xlabel('epoch')
        plt.title('Model Loss')
        plt.legend()
        plt.subplot(122)
        plt.plot(self.x, self.acc, label="training accuracy")
        plt.plot(self.x, self.val_acc, label="validation accuracy")
        plt.legend()
        plt.ylabel('accuracy')
        plt.xlabel('epoch')
        plt.title('Model Accuracy')
        plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))
        plt.show();

def display_learning_curves(history):
    # Extract training and validation accuracy values (percentage of correctly classified examples in a validation dataset).
    acc = history.history["accuracy"]
    val_acc = history.history["val_accuracy"]

    # Extract training and validation loss values (quantifies the difference between the model's predictions and the true labels in the validation dataset).
    loss = history.history["loss"]
    val_loss = history.history["val_loss"]

    # Define the range of epochs based on the specified 'NUM_EPOCHS'.
    epochs_range = range(num_epochs)

    # Create a figure for plotting.
    fig = plt.figure(figsize=(12, 6))

    # Plot the training and validation accuracy.
    plt.subplot(1, 2, 1)
    plt.plot(epochs_range, acc, label="train accuracy")
    plt.plot(epochs_range, val_acc, label="validation accuracy")
    plt.title("Accuracy")
    plt.xlabel("Epoch")
    plt.ylabel("Accuracy")
    plt.legend(loc="lower right")

    # Plot the training and validation loss.
    plt.subplot(1, 2, 2)
    plt.plot(epochs_range, loss, label="train loss")
    plt.plot(epochs_range, val_loss, label="validation loss")
    plt.title("Loss")
    plt.xlabel("Epoch")
    plt.ylabel("Loss")
    plt.legend(loc="upper right")

    # Adjust the layout and display the figure.
    fig.tight_layout()
    plt.show()
