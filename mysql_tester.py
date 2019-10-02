import mysql.connector
import re
import socket

from flask import Flask, request, render_template, flash
from wtforms import Form, TextField, validators


class ReusableForm(Form):
    rds_ip = TextField('IP Address of RDS Instance:', validators=[validators.DataRequired()])


# Instantiate our Node
app = Flask(__name__)
app.config.from_object(__name__)
app.config['SECRET_KEY'] = '7d441f27d441f27567d441f2b6176a'

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
            # Check if the IP address format is ok
            m = re.search(r'^[1-2]?\d{1,2}\.[1-2]?\d{1,2}\.[1-2]?\d{1,2}\.[1-2]?\d{1,2}$', rds_ip)
            
            if (m):
                flash('RDS IP is: ' + rds_ip)
                
                # Open connection to the mysql server
                conn = mysql.connector.connect(host=rds_ip, user='root', password='Huawei@12')
                cursor = conn.cursor()

                query = ("SHOW DATABASES")

                cursor.execute(query)

                for item in cursor:
                    flash(item[0])

                cursor.close()
                conn.close()
            else:
                flash("Please enter a valid IP address.")
        else:
            flash('All the form fields are required. ')
 
    return render_template('hello.html', form=form)

if (__name__ == '__main__'):
    app.run(host='0.0.0.0', port=5000)
