import numpy as np
import pandas as pd
import sklearn as sk
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn.model_selection import train_test_split
import pickle

def printModelScore(loaded_model, x_train, x_test, y_train, y_test):
    y_test_pred = loaded_model.predict(x_test)
    accte = accuracy_score(y_test, y_test_pred)
    print(model_name)
    print(confusion_matrix(y_test, y_test_pred))
    print("Accuracy", accte)


file_path = "C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/"
model_name = "Neural Network"

# Load model from file
with open(file_path + model_name + ".pkl", 'rb') as file:
    loaded_model = pickle.load(file)

# load data
train_data = pd.read_csv("C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/train_data.csv")


# split train and test data
x_data = train_data.copy()
x_data.drop("ocr", axis=1, inplace=True)
y_data = train_data["ocr"]
x_train, x_test, y_train, y_test = train_test_split(x_data, y_data, random_state=0)


printModelScore(loaded_model, x_train, x_test, y_train, y_test)