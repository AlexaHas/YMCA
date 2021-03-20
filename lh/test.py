from flask import Flask, request
from server import classifyStation


app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'name: John Smith'

@app.route('/classify')
def stationRequest():
    station_name = request.args.get("station_name")
    time = request.args.get("time")
    result = classifyStation(station_name, time)
    return result

#def result():
#    print(request.data)  # raw data
#    print(request.json)  # json (if content-type of application/json is sent with the request)
#    print(request.get_json(force=True))  # json (if content-type of application/json is not sent)

if __name__ == "__main__":
    app.run(host="0.0.0.0")
