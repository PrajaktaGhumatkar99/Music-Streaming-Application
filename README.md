# Streaming-Database
CS 5200 Databases Project
Group: RiouxSGhumatkarP

### Prerequisites:
1. Python version 3.x (Link to download python--> https://www.python.org/downloads/)
2. MySQL Community Server 8.0 and above (Link to download mysql community server--> https://dev.mysql.com/downloads/mysql/)
3. Operating System: Windows 10/8/7, Linux, MacOS
4. Minimum 128 MB Ram
5. Minimum 10 MB of free storage
6. All necessary packages & modules mentioned above under the "Python Libraries to install" section should be installed on the system before hosting this program

###  Python libraries to install
1. Install pymysql - pip install pymysql
2. Install cryptography - pip install cryptography
3. Install flask - pip install flask
4. Install flask-pymysql - pip install flask-pymysql

###  Import Database Dump into MySQL Workbench
Open StreamingDatabaseDump.sql file in the root directory. Run these commands

### Create new virtual environment variable
1. Ensure Python is installed on your machine and it is able to run through the command prompt or terminal. Check the installation using:
  
  	1.1 Windows Command Prompt:
      		python --version
  
 	 1.2 Unix:
      		python3 --version
      
2. Navigate into project directory
	
	2.1. Windows Command Prompt:
	    cd RiouxSGhumatkarPProject\Streaming-Database\FlaskApp
	
	2.2. Unix:
	    cd RiouxSGhumatkarPProject/Streaming-Database/FlaskApp

3. Run the following command : 
  
  	3.1. Windows Command Prompt:
      		python -m venv <name_of_virtualenv>
  
  	3.2. Unix:
      		python3 -m venv <name_of_virtualenv>

4. Activate virtual environment 
  
  	4.1. Windows:
     		<name_of_virtualenv> \Scripts\activate
  
  	4.2. Unix:
      		source <name_of_virtualenv> /bin/activate
      
###  Run Application
1. Open db_config.py in the FlaskApp folder and change the DB_SERVER, DB_USER and DB_PASS according to your mysql credentials
2. Navigate to the FlaskApp folder in the terminal and run the following command : 
python app.py
3. Copy the link in the terminal and paste in a browser
4. Interact with the application




