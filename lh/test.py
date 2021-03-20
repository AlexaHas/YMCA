from flask import Flask, request
from server import classifyStation
import pandas as pd


app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'name: John Smith'

@app.route('/classify')
def stationRequest():
    station_name = request.args.get("station_name")
    time = request.args.get("time")
    #time = time.replace("%3A", ":")
    #time = time.replace("%2B", "+")
    result = classifyStation(station_name, time)
    return result


@app.route('/search')
def stationSearch():
    searchTerm = request.args.get("searchTerm")
    station_list = pd.read_excel("../resources/train_stations_clean.xlsx")
    result = station_list.loc[
        station_list["station"].str.lower().str.startswith(searchTerm.lower(), na=False), "station"]
    result_json = {"Stations": result.tolist()}
    return result_json

#def result():
#    print(request.data)  # raw data
#    print(request.json)  # json (if content-type of application/json is sent with the request)
#    print(request.get_json(force=True))  # json (if content-type of application/json is not sent)

if __name__ == "__main__":
    app.run(host="0.0.0.0")
