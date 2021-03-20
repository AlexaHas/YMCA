import numpy as np
import pandas as pd


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

# import data for occupancy rate
raw_ocr_data = pd.read_csv('C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/park-ride-rapperswil.csv', delimiter=";")

raw_ocr_data.columns = ["date", "ocr"]

# import data for occupancy rate
raw_station_data = pd.read_csv('C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/mobilitat.csv', delimiter=";")

# adding the station code (RW)
station_ocr_data = raw_ocr_data.copy()
station_ocr_data["station_code"] = "RW"
station_ocr_data["ocr"] = station_ocr_data["ocr"]/100

## data cleaning

#print(station_ocr_data.info())
#print(station_ocr_data.describe())

# data seems to be in good condition

## feature engineering

# extracting the time(hour) from the date field
station_ocr_data["time"] = station_ocr_data["date"].apply(lambda x: pd.to_datetime(x).time())
station_ocr_data["week_of_year"] = station_ocr_data["date"].apply(lambda x: pd.to_datetime(x).weekofyear)
station_ocr_data["month"] = station_ocr_data["date"].apply(lambda x: pd.to_datetime(x).month)
station_ocr_data["day"] = station_ocr_data["date"].apply(lambda x: pd.to_datetime(x).day)
station_ocr_data["workday"] = station_ocr_data["date"].apply(lambda x: 1 if pd.to_datetime(x).weekday() < 5 else 0) # weekday returns 0 = Monday to 6 = Sunday -> used to test for work days
station_ocr_data["holiday"] = station_ocr_data["date"].apply(lambda x: testForHolidy(pd.to_datetime(x).day, pd.to_datetime(x).month))





