import os
from flask import Flask, render_template, redirect, url_for, request
import requests, json
from requests.auth import HTTPBasicAuth
import db.hosts

#settings stored as replit secrets
# wt_username = os.environ['wt_username']
# wt_password = os.environ["wt_password"]
# wt_email = os.environ["wt_email"]
# wt_org = os.environ["wt_org"]

# #logging in
# login_url = 'https://api2.watttime.org/v2/login'
# token = requests.get(login_url, auth=HTTPBasicAuth(wt_username, wt_password)).json()['token']


# Parsing the page
# (We need to use page.content rather than
# page.text because html.fromstring implicitly
# expects bytes as input.)


app = Flask(__name__)

# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test.db'

# db = SQLAlchemy(app)

#EXAMPLE CURL COMMAND
#curl -X POST https://dukecarbonhack.aryanmathur4.repl.co/watt -d hid,0,power,123


@app.route('/')
def base():
    return render_template("index.html")


@app.route('/table')
def servertable():
  hosts = db.hosts.getAllHosts()
  locations = [x[-2] for x in hosts]
  locSet = list(set(locations))
  #requesting GSF API
  data_url = 'https://carbon-aware-api.azurewebsites.net/emissions/bylocations'
  headers = {'accept': 'application/json'}
  params = {'location': locations}
  rsp = requests.get(data_url, headers=headers, params=params)
  output = rsp.json()
  ratings = []
  for loc in locations:
    i = locSet.index(loc)
    ratings.append(output[i]['rating'])


  print(ratings)
  return render_template("servertable.html", hosts=hosts, ratings=ratings)

@app.route('/about')
def aboutus():
  return render_template("aboutus.html")

@app.route('/login')
def login():
  return render_template("login.html")

@app.route('/signup')
def signup():
  return render_template("signup.html")

@app.route('/watt', methods = ['POST', 'GET'])
def watt():
  
  data = str(request.get_data(), 'UTF-8').split(',')

  if(data[3] == 'end'):
    db.hosts.resetPower(int(data[1]))
    return "host power reset"
  
  db.hosts.updatePower(int(data[1]), float(data[3]))
  return "watt info receieved"

app.run(host='0.0.0.0', port=81)
