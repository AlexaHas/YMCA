import numpy as np
import pandas as pd
import sklearn as sk
import matplotlib.pyplot as plt
from sklearn.metrics import accuracy_score, confusion_matrix

# import data for occupancy rate
raw_ocr_data = pd.read_csv('C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/park-ride-rapperswil.csv', delimiter=";")

raw_ocr_data.columns = ["date", "ocr"]

# import data for occupancy rate
raw_station_data = pd.read_csv('C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/mobilitat.csv', delimiter=";")

# adding the station code (RW)
station_ocr_data = raw_ocr_data.copy()
station_ocr_data["station_code"] = "RW"
station_ocr_data["ocr"] = station_ocr_data["ocr"]/100

# data cleaning
print(station_ocr_data.info())
print(station_ocr_data.describe())
# data seems to be in good condition

## feature engineering



