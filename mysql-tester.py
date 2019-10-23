"""
Main Application which lists databases in the AWS RDS instance
It uses Kubernetes External service to reach RDS
"""

import mysql.connector
import socket
import os

from flask import Flask, request, render_template, flash
from wtforms import Form, TextField, validators


class ReusableForm(Form):
    rds_ip = TextField('RDS Service Name:', validators=[validators.DataRequired()])


# Instantiate our Node
app = Flask(__name__)

@app.route("/", methods=['GET', 'POST'])
def hello():
    # Get host name and pass it to the template
    hostname = socket.gethostname().split(".")[0]
    flash(hostname)
    
    # Proceed to the form
    form = ReusableForm(request.form)
 
    print(form.errors)
    
    if (request.method == 'POST'):
        rds_ip = request.form['rds_ip']
 
        if (form.validate()):
            flash('RDS Service Name is: ' + rds_ip)

            # Open connection to the mysql server
            host_ip = os.environ[rds_ip.upper() + "_SERVICE_HOST"]
            print("Target service IP address is ", host_ip)
            
            username = os.environ["RDS_USERNAME"]
            password = os.environ["RDS_PASSWORD"]
                  
            conn = mysql.connector.connect(host=host_ip, user=username, password=password)
            cursor = conn.cursor()

            query = ("SHOW DATABASES")

            cursor.execute(query)

            for item in cursor:
                flash(item[0])

            cursor.close()
            conn.close()
        else:
            flash('All the form fields are required. ')
 
    return render_template('hello.html', form=form)

if (__name__ == '__main__'):
    app.run(host='0.0.0.0', port=5000)
