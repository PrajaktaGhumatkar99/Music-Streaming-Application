from flask import Flask, render_template, request, url_for, session, redirect
from flask_pymysql import MySQL
import re
import pymysql

app = Flask(__name__)

app.secret_key = 'streamtime'

#Set up pymysql connection arguments
pymysql_connect_kwargs = {'user': 'root', 'password': 'T5zh22qa!', 'host': 'localhost',
                          'database': 'streamingdatabase', }

app.config['pymysql_kwargs'] = pymysql_connect_kwargs
mysql = MySQL(app)


"""

Login Page

"""
@app.route("/")
@app.route("/login", methods=['GET', 'POST'])
def login():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
    if request.method == 'POST' and 'email' in request.form and 'phone' in request.form:

        # Create variables for easy access
        email = request.form['email']
        phone = request.form['phone']
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor()

        cursor.execute('SELECT findUser(%s, %s) as foundUser', (email, phone,))
        account = cursor.fetchone()

        # If account exists in accounts table in out database
        if account:
            # Create session data, we can access this data in other routes
            session['loggedin'] = True
            session['id'] = account[0]
            session['email'] = email
            # Redirect to home page
            return redirect(url_for('home'))
        else:
            # Account doesnt exist or username/password incorrect
            msg = 'Incorrect username/password!'
    # Show the login form with message (if any)
    return render_template('login.html', msg=msg)


"""

Logout Page

"""
@app.route('/logout')
def logout():
    # Remove session data, this will log the user out
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    # Redirect to login page
    return redirect(url_for('login'))



"""

Register Page

"""
@app.route('/register', methods=['GET', 'POST'])
def register():
    # Output message if something goes wrong...
    msg = ''
    #Get payment plan information for registration
    cursor = mysql.connection.cursor(pymysql.cursors.DictCursor)
    cursor.execute('call getPaymentPlans()')
    paymentPlans = cursor.fetchall()
    print(paymentPlans)
    # Check if firstname, lastname, email, phone and plan are selected
    if request.method == 'POST' and 'firstName' in request.form and 'lastName' in request.form and 'email' in request.form and 'phone' in request.form and 'plan' in request.form:
        # Create variables for easy access
        firstName = request.form['firstName']
        lastName = request.form['lastName']
        email = request.form['email']
        phone = request.form['phone']
        plan = request.form['plan']
        print(request.form)

        # Check if account exists in database
        cursor.execute('SELECT findUser(%s, %s) as foundUser', (email, phone,))
        account = cursor.fetchone()

        # If account exists show error and validation checks
        if account['foundUser']:
            msg = 'Account already exists!'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            msg = 'Invalid email address!'
        elif not re.match(r'[A-Za-z]+', firstName):
            msg = 'Name must cotain only characters!'
        elif not re.match(r'[A-Za-z]+', lastName):
            msg = 'Name must cotain only characters!'
        elif not firstName or not lastName or not email or not phone or not plan:
            msg = 'Please fill out the form!'
        else:
            # Account doesnt exists and the form data is valid, now insert new account into accounts table
            cursor.execute('call createUser(%s, %s, %s, %s, %s)',
                           (firstName, lastName, email, phone, plan))
            mysql.connection.commit()
            msg = 'You have successfully registered!'
    elif request.method == 'POST':
        # Form is empty... (no POST data)
        msg = 'Please fill out the form!'
    # Show registration form with message (if any)
    return render_template('register.html', msg=msg, paymentplans = paymentPlans)


"""

Home Page

"""
@app.route('/home')
def home():
    # Check if user is loggedin
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute(
            'SELECT * FROM playlists WHERE userId = %s', (session['id']))
        playlists = list(cursor.fetchall())
        print(playlists)
        return render_template('home.html', username=session['email'], playlists = playlists)
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

"""

Profile Page

"""
@app.route('/profile')
def profile():
    # Check if user is loggedin
    if 'loggedin' in session:
        return render_template('profile.html', username=session['email'])
        
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

"""

New Playlist Page

"""
@app.route('/newplaylist', methods=['GET', 'POST'])
def newplaylist():
    # Check if user is loggedin
    if 'loggedin' in session:
        if request.method == 'POST' and 'name' in request.form:
            name = request.form['name']
            status = request.form['status']
            print('MY USER', session['id'])
            cursor = mysql.connection.cursor(pymysql.cursors.DictCursor)
            cursor.execute('INSERT INTO playlists VALUES (0, %s, %s, %s)',
                           (name, status, int(session['id'])))
            mysql.connection.commit()
             # Redirect to home page
            return redirect(url_for('home'))
        return render_template('newplaylist.html', username=session['email'])
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))


"""

Playlist Page

"""
@app.route('/playlist/<playlist_id>', methods=['GET', 'POST'])
def playlist(playlist_id = 0):
    if 'loggedin' in session:
        if request.method == 'POST' and 'add' in request.form:
            song_id = request.form['add']
            cursor = mysql.connection.cursor(pymysql.cursors.DictCursor)
            cursor.execute('INSERT INTO playlistsong VALUES (%s, %s)',
                           (playlist_id, song_id))
            mysql.connection.commit()
        
        if request.method == 'POST' and 'delete' in request.form:
            song_id = request.form['delete']
            cursor = mysql.connection.cursor()
            cursor.execute('call removeSongFromPlaylist(%s, %s)',
                           (playlist_id, song_id))
            mysql.connection.commit()
        cursor = mysql.connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute('SELECT * FROM songs')
        songs = list(cursor.fetchall())
        print(songs)

        cursor.execute('call getPlaylistSongs(%s)', (playlist_id))
        playlistsongs = list(cursor.fetchall())

        print(playlistsongs)

        return render_template('playlist.html', username=session['email'], songs = songs, playlistsongs = playlistsongs)
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)
