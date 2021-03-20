import numpy as np
import pandas as pd
import sklearn as sk
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn.model_selection import train_test_split
import pickle

# function to train model
def trainModel(model, model_name, param_grid, x_train, x_test, y_train, y_test):
    CV_model = GridSearchCV(estimator=model, param_grid=param_grid, cv=5)
    CV_model.fit(x_train, y_train)
    print(CV_model.best_params_)

    # use the best parameters
    model = model.set_params(**CV_model.best_params_)
    model.fit(x_train, y_train)
    y_test_pred = model.predict(x_test)
    accte = accuracy_score(y_test, y_test_pred)

    print(model_name)
    print(confusion_matrix(y_test, y_test_pred))
    print("Accuracy", accte)

    # save model
    with open("C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/" + model_name + ".pkl", 'wb') as file:
        pickle.dump(model, file)

# load clean data
train_data = pd.read_csv("C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/train_data.csv")

# split train and test data
x_data = train_data.copy()
x_data.drop("ocr", axis=1, inplace=True)
y_data = train_data["ocr"]

x_train, x_test, y_train, y_test = train_test_split(x_data, y_data, random_state=0)

#################
# Random Forest #
#################
param_grid_rf = {
    'max_depth': [ 26, 28, 30, 32],
    'n_estimators': [ 150, 175, 200, 225]
}

#rfmodel = RandomForestClassifier(random_state=0, class_weight="balanced")
#trainModel(rfmodel, "Random Forest",param_grid_rf,x_train, x_test, y_train, y_test)

#################
# Neural Network #
#################

param_grid_nn = {
    'hidden_layer_sizes': [(9,9,9), (9,9,9,9)],
    'learning_rate_init': [0.01]
}

#nnmodel = MLPClassifier(solver='sgd', random_state=0, max_iter=500)
#trainModel(nnmodel, "Neural Network", param_grid_nn,x_train, x_test, y_train, y_test)


#################
# KNN #
#################

param_grid_knn = {
    'n_neighbors': [ 12, 13, 14]
}


#knnmodel = KNeighborsClassifier()
#trainModel(knnmodel, "KNN", param_grid_knn,x_train, x_test, y_train, y_test)