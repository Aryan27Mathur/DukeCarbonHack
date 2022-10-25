import os
from flask import Flask, render_template, redirect, url_for, request
import requests
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
data_url = 'https://api2.watttime.org/v2/data'
headers = {'Authorization': 'Bearer {}'.format(token)}
params = {'ba': 'CAISO_NORTH', 
          'starttime': '2019-02-20T16:00:00-0800', 
          'endtime': '2019-02-20T16:15:00-0800'}
rsp = requests.get(data_url, headers=headers, params=params)
print(rsp.text)

app = Flask(__name__)


@app.route('/')
def index():
    return render_template("base.html", apicall = rsp.text)


app.run(host='0.0.0.0', port=81)
