import numpy as np
import pandas as pd
import sklearn as sk
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn.model_selection import train_test_split
import pickle

# tests if a given date is around a swiss holiday
def testForHolidy(day, month):
    # list of all swiss holidays as string combination of day and month
    allHolidays = ["11", "21", "307", "317", "18", "28", "38", "2212", "2312", "2412", "2512", "2612", "2712", "2612", "3012", "3112"]

    # combine day and month like strings instead of as numbers
    combined_date = str(day)+str(month)
    if combined_date in allHolidays:
        return 1
    else:
        return 0

def classifyStation(rail_station, date_time):
    station_list = pd.read_excel("../resources//train_stations_clean.xlsx")
    input_data = pd.DataFrame(station_list.loc[station_list["station"] == rail_station, "station_code"], columns=["station_code"]).reset_index(drop=True)
    time = pd.to_datetime(date_time).hour
    week_of_year = pd.to_datetime(date_time).weekofyear
    month = pd.to_datetime(date_time).month
    day = pd.to_datetime(date_time).day
    input_data["workday"] = 1 if pd.to_datetime(date_time).weekday() < 5 else 0  # weekday returns 0 = Monday to 6 = Sunday -> used to test for work days
    input_data["holiday"] = testForHolidy(pd.to_datetime(date_time).day, pd.to_datetime(date_time).month)

    # scale data
    x_std = (week_of_year - 1) / (52 - 1)
    input_data["week_of_year"] = x_std * (1 - 0) + 0
    x_std = (month - 1) / (12 - 1)
    input_data["month"] = x_std * (1 - 0) + 0
    x_std = (day - 1) / (31 - 1)
    input_data["day"] = x_std * (1 - 0) + 0

    for i in range(1, 24):
        if i<10:
            if time == i:
                input_data["time_0"+str(i)+":00:00"] = 1
            else:
                input_data["time_0" + str(i) + ":00:00"] = 0
        else:
            if time == i:
                input_data["time_" + str(i) + ":00:00"] = 1
            else:
                input_data["time_" + str(i) + ":00:00"] = 0

    # reorder columns
    input_data = input_data.reindex(columns=["week_of_year","month","day","workday","holiday","time_01:00:00","time_02:00:00","time_03:00:00","time_04:00:00","time_05:00:00","time_06:00:00","time_07:00:00","time_08:00:00","time_09:00:00","time_10:00:00","time_11:00:00","time_12:00:00","time_13:00:00","time_14:00:00","time_15:00:00","time_16:00:00","time_17:00:00","time_18:00:00","time_19:00:00","time_20:00:00","time_21:00:00","time_22:00:00","time_23:00:00"])
    print(input_data.columns)

    # load model
    file_path = "../resources/"
    model_name = "Neural Network"

    # Load model from file
    with open(file_path + model_name + ".pkl", 'rb') as file:
        loaded_model = pickle.load(file)

    result = loaded_model.predict(input_data)
    result = result[0]
    print("Result:", result)
    return result


classifyStation("Zug", "2020-08-01T04:00:00+02:00")