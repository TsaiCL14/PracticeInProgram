# This Python 3 environment comes with many helpful analytics libraries installed
# It is defined by the kaggle/python Docker image: https://github.com/kaggle/docker-python
# For example, here's several helpful packages to load

from keras.utils import to_categorical
from keras.layers import Dense
from keras.models import Sequential
from sklearn.model_selection import train_test_split
import numpy as np  # linear algebra
import pandas as pd  # data processing, CSV file I/O (e.g. pd.read_csv)

# Input data files are available in the read-only "../input/" directory
# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory

# import os
# for dirname, _, filenames in os.walk('/kaggle/input'):
#     for filename in filenames:
#         print(os.path.join(dirname, filename))

# You can write up to 20GB to the current directory (/kaggle/working/) that gets preserved as output when you create a version using "Save & Run All"
# You can also write temporary files to /kaggle/temp/, but they won't be saved outside of the current session

df = pd.read_csv("data/kaggle_bot_accounts.csv")
df.info()
print(df.isnull().sum())
print(df)

df = df.drop(columns=['Unnamed: 0', 'NAME', 'EMAIL_ID',
             'REGISTRATION_IPV4', 'REGISTRATION_LOCATION'])
df = df.dropna()
df

# Converting Boolean values to binary
df['IS_GLOGIN'] = df['IS_GLOGIN'].astype(int)
df['ISBOT'] = df['ISBOT'].astype(int)
# Converting gender to dummy
df = pd.get_dummies(df)
df.reset_index(drop=True)

# Creating X and y
y = df['ISBOT']
X = df.drop(columns='ISBOT')
print(X)
print(y)
print(X.shape)

# Importing necessary packages

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=.25, random_state=42)

y_train = to_categorical(y_train)
y_test = to_categorical(y_test)

print(y_train.shape[1])

# Define model
model = Sequential()
model.add(Dense(25, activation='relu', input_dim=12))
model.add(Dense(12, activation='relu'))
model.add(Dense(6, activation='relu'))
model.add(Dense(2, activation='sigmoid'))

# compile model
model.compile(optimizer='adam', loss='binary_crossentropy',
              metrics=['accuracy'])

# build model
model.fit(X_train, y_train, epochs=5)

test_loss, test_acc = model.evaluate(X_test, y_test)
print('Test accuaracy:', test_acc)
