
#Account Registration Code used

# import requests
# from requests.auth import HTTPBasicAuth


# register_url = 'https://api2.watttime.org/v2/register'
# params = {'username': wt_username,
#          'password': wt_password,
#          'email': wt_email,
#          'org': wt_org}
# rsp = requests.post(register_url, json=params)
# print(rsp.text)

# login_url = 'https://api2.watttime.org/v2/login'
# rsp = requests.get(login_url, auth=HTTPBasicAuth(wt_username, wt_password))
# print(rsp.json())

# login_url = 'https://api2.watttime.org/v2/login'
# token = requests.get(login_url, auth=HTTPBasicAuth(wt_username, wt_password)).json()['token']