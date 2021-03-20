import pandas as pd
import sklearn as sk
from sklearn.preprocessing import MinMaxScaler

# load clean data
clean_data = pd.read_csv("C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/clean_data.csv")

## preprocessing
print(clean_data.dtypes)

# list of columns with categorical data to ctreate dummies for
cat_columns = ["time", "station_code", "workday", "holiday"]

# split into categorical and numerical data
num_data = clean_data.drop(cat_columns, axis=1)
num_data.drop("ocr", axis=1, inplace=True)
dummy_data = clean_data[cat_columns]
target_data = clean_data["ocr"]

# create dummies
with_dummy_data = pd.get_dummies(dummy_data, drop_first=True)

# standardise numeric values
scaler = MinMaxScaler()
scaler.fit(num_data)
stand_num_data =pd.DataFrame(scaler.transform(num_data), index=num_data.index, columns=num_data.columns)
#print(stand_num_data.describe())

# create 4 categories for the target column
cat_target_data = pd.cut(target_data, bins=[-float("inf"), 0.25, 0.5, 0.75, float("inf")], labels=["free", "little", "medium", "high"])
print(cat_target_data.value_counts())

# merge data back together
full_data = stand_num_data.merge(with_dummy_data, left_index = True, right_index = True)
pre_data = full_data.merge(cat_target_data, left_index = True, right_index = True)

print(pre_data.head().T)

pre_data.to_csv("C:/Users/Yannik/Documents/Hackerthon/Start Hack 2021/Data/train_data.csv",  index=False)