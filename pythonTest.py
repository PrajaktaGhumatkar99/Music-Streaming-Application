import pymysql

db = None
print("Streaming Database")
try:
    db = pymysql.connect(host='localhost', user='root', password='T5zh22qa!',
                db='streamingdatabase',charset='utf8mb4',cursorclass=pymysql.cursors.DictCursor )

    email = input("Enter email address: ")
    phone = input("Enter phone number: ")

    sqlQuery = "select findUser(" + "\"" + email +"\"," +  "\""+ phone + "\"" +")"
    cur = db.cursor()

    cur.execute(sqlQuery)
    user = cur.fetchone()

    print(user)
    

except pymysql.err.OperationalError as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]) )
if db:
    db.close()