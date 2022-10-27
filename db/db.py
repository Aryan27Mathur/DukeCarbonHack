import sqlite3
import csv




# class Hosts(db.Model):
#   hid = db.Column(db.Integer, primary_key=True)
#   cost = db.Column(db.Float)
#   hardware= db.Column(db.String(200))
#   location = db.Column(db.String(200))

def createHosts():
  conn = sqlite3.connect('hosts.db')
  c = conn.cursor()
  c.execute(
  """
  CREATE TABLE Hosts(
  hid integer,
  cost real,
  hardware text,
  location text
  )
  """
  )
  conn.commit()
  conn.close()

  

#c.execute("""INSERT INTO Hosts VALUES (1, 13.2, 'RTX2070', 'centralus')""")

def getAllHosts():
  conn = sqlite3.connect('hosts.db')
  c = conn.cursor()
  c.execute("""
SELECT * FROM hosts;
""")
  print(c.fetchall())

  conn.commit()
  conn.close()

def clearHosts():
  conn = sqlite3.connect('hosts.db')
  c = conn.cursor()
  c.execute("""
DROP TABLE hosts;
""")
  conn.commit()
  conn.close()
  createHosts()

def importHosts():
  conn = sqlite3.connect('hosts.db')
  c = conn.cursor()
  
  with open('data/hosts.csv') as myFile:
    csv_reader = csv.reader(myFile, delimiter=',')
    for row in csv_reader:
      query = "INSERT INTO Hosts VALUES ({0}, {1}, {2}, {3})".format(row[0],row[1],row[2],row[3])
      c.execute(query)

  conn.commit()
  conn.close()

def getAllHardware():
  conn = sqlite3.connect('hosts.db')
  c = conn.cursor()
  c.execute()

# createHosts()
# importHosts()
# getAllHosts()


  