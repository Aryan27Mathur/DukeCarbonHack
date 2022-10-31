import sqlite3
import csv

def createClients():
  conn = sqlite3.connect('data.db')
  c = conn.cursor()
  c.execute(
  """
  CREATE TABLE Clients(
  hid integer,
  cost real,
  hardware text,
  location text
  )
  """
  )
  conn.commit()
  conn.close()


