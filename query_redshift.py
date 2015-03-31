""" This script can hit our Redshift Database.
Config File
You must have the config file in the same folder as this script. 
We will not be putting credentials on git.
Please email Max Roth if you would like the config file or 
download the file config.py and fill in the credentials.
Output
This script will save the output as data.csv file. Once you run the script, you can play with the data in
a pandas dataframe called rows.
Jira Tickets: DS-46
"""
import csv
import time

import psycopg2

import config

# Redshift Credentials stored in the config file. The file config.py should be in the same folder at this scipt.
"""
configuration = { 'dbname': <Data Base Name Here>, 
                  'user':<Your User Name Here>,
                  'pwd': <Your Password>,
                  'host':'ABC.us-east-1.redshift.amazonaws.com',
                  'port':'5439'
                }
"""
configuration = config.configuration

def create_conn(*args,**kwargs):
  "Function to connect to the database" 
  config = kwargs['config']
  try:
    conn=psycopg2.connect(dbname=config['dbname'], 
      host=config['host'],
      port=config['port'], 
      user=config['user'],
      password=config['pwd'])
  except Exception as err:
    print(err.code, err)
  return conn

def make_query(*args,**kwargs):


  """ Open a cursor to perform database operations 
  need a connection with dbname=<username>_db
  """
  cur = kwargs['cur']
  try:

      # retrieving all tables in my search_path
    cur.execute("""select fpd.partyid, fpd.experiencelevel
                   from fact_persondata fpd
                   left join fact_docmetadata fdm on fpd.documentid = fdm.documentid
                   where fpd.data_source_id=1
                   and fdm.documenttypecd in ('RSME')
                   order by fpd.partyid
                   limit 10""")
  except Exception as error:
    print(error.code,error)

  rows = cur.fetchall()
  with open('data.csv', 'a') as f:
    write = csv.writer(f)
    for row in rows:
      write.writerow(row)
    print(row)

def main():
    print('Starting...')
    conn = create_conn(config=configuration)
    cursor = conn.cursor()
    print('Start selecting...')
    start = time.time() 
    make_query(cur=cursor)
    print('Script Clock: ', '{0:.3g}'.
      format(abs(time.time()-start)), 'secconds')
    print('Finished.')
     
    cursor.close()

if __name__ == '__main__':
    main()
