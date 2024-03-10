from keras.layers import Input, Conv2D, MaxPool2D, Dropout, BatchNormalization, concatenate, UpSampling2D
from keras.models import Model

def unet_model(input_size=(1080, 1920, 3)):
    inputs = Input(input_size)

    # Encoder
    conv1 = Conv2D(8, 10, activation='relu', padding='same')(inputs)
    conv1 = Conv2D(8, 10, activation='relu', padding='same')(conv1)
    conv1 = BatchNormalization(synchronized=True)(conv1)
    pool1 = MaxPool2D(2)(conv1)
    pool1 = Dropout(.2)(pool1)

    conv2 = Conv2D(16, 10, activation='relu', padding='same')(pool1)
    conv2 = Conv2D(16, 10, activation='relu', padding='same')(conv2)
    conv2 = BatchNormalization(synchronized=True)(conv2)
    pool2 = MaxPool2D(2)(conv2)
    pool2 = Dropout(.2)(pool2)

    conv3 = Conv2D(32, 10, activation='relu', padding='same')(pool2)
    conv3 = Conv2D(32, 10, activation='relu', padding='same')(conv3)
    conv3 = BatchNormalization(synchronized=True)(conv3)
    pool3 = MaxPool2D(2)(conv3)
    pool3 = Dropout(.2)(pool3)

    # Bottom
    conv4 = Conv2D(64, 10, activation='relu', padding='same')(pool3)
    conv4 = Conv2D(64, 10, activation='relu', padding='same')(conv4)
    conv4 = BatchNormalization(synchronized=True)(conv4)
    conv4 = Dropout(.2)(conv4)

    # Decoder
    up5 = concatenate([UpSampling2D(2)(conv4), conv3], axis=-1)
    conv5 = Conv2D(32, 10, activation='relu', padding='same')(up5)
    conv5 = Conv2D(32, 10, activation='relu', padding='same')(conv5)
    conv5 = BatchNormalization(synchronized=True)(conv5)
    conv5 = Dropout(.2)(conv5)

    up6 = concatenate([UpSampling2D(2)(conv5), conv2], axis=-1)
    conv6 = Conv2D(16, 10, activation='relu', padding='same')(up6)
    conv6 = Conv2D(16, 10, activation='relu', padding='same')(conv6)
    conv6 = BatchNormalization(synchronized=True)(conv6)
    conv7 = Dropout(.2)(conv6)

    up7 = concatenate([UpSampling2D(2)(conv6), conv1])
    conv7 = Conv2D(8, 10, activation='relu', padding='same')(up7)
    conv7 = Conv2D(8, 10, activation='relu', padding='same')(conv7)
    conv7 = BatchNormalization(synchronized=True)(conv7)
    conv7 = Dropout(.2)(conv7)

    # Output layer
    outputs = Conv2D(1, (1, 1), activation='sigmoid')(conv7)

    model = Model(inputs=inputs, outputs=outputs)

    return model
