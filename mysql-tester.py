"""
Main Application which lists databases in the AWS RDS instance
It uses Kubernetes External service to reach RDS
"""

import mysql.connector
import socket
import os
import logging

from flask import Flask, request, render_template, flash
from wtforms import Form, TextField, validators
from flask.logging import create_logger


class ReusableForm(Form):
    rds_ip = TextField('RDS Service Name:', validators=[validators.DataRequired()])


# Instantiate our Node
app = Flask(__name__)

app.config.from_object(__name__)
app.config['SECRET_KEY'] = '7d441f27d441f27567d441f2b6176a'

LOG = create_logger(app)
LOG.setLevel(logging.INFO)

@app.route("/", methods=['GET', 'POST'])
def hello():
    # Get host name and pass it to the template
    hostname = socket.gethostname().split(".")[0]
    flash(hostname)
    
    # Proceed to the form
    form = ReusableForm(request.form)
    print(form.errors)
    
    if (request.method == 'POST'):
        host_ip = os.environ["RDS_SERVICE_HOST"]
        flash(host_ip)

        # Open connection to the mysql server
        LOG.info("About to make a request to the target service IP of ", host_ip)
                  
        conn = mysql.connector.connect(host=host_ip, user=os.environ["RDS_USER"], password=os.environ["RDS_PASS"])
        cursor = conn.cursor()

        query = ("SHOW DATABASES")

        cursor.execute(query)

        for item in cursor:
            flash(item[0])

        cursor.close()
        conn.close()
 
    return render_template('hello.html', form=form)

if (__name__ == '__main__'):
    app.run(host='0.0.0.0', port=5000)
