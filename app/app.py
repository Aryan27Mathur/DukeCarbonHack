import os
from flask import Flask, render_template, redirect, url_for, request
import requests, json
from requests.auth import HTTPBasicAuth


#settings stored as replit secrets
wt_username = os.environ['wt_username']
wt_password = os.environ["wt_password"]
wt_email = os.environ["wt_email"]
wt_org = os.environ["wt_org"]

#logging in
login_url = 'https://api2.watttime.org/v2/login'
token = requests.get(login_url, auth=HTTPBasicAuth(wt_username, wt_password)).json()['token']



#requesting GSF API
data_url = 'https://carbon-aware-api.azurewebsites.net/emissions/bylocation?location=centralus'
headers = {'accept': 'application/json'}
params = {'location': 'centralus'}
rsp = requests.get(data_url, headers=headers, params=params)
output = rsp.json()[0]['rating']

app = Flask(__name__)

# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test.db'

# db = SQLAlchemy(app)


  

@app.route('/')
def index():
    return render_template("base.html", apicall = output)


app.run(host='0.0.0.0', port=81)
