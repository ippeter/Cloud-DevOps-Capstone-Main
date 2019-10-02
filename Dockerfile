FROM python:2.7.16-alpine3.9

WORKDIR /root

RUN pip install --upgrade pip && pip install --trusted-host pypi.python.org -r requirements.txt

RUN mkdir templates
COPY hello.html templates/hello.html
COPY mysql_tester.py mysql_tester.py

ENV FLASK_APP mysql_tester.py

CMD ["python", "mysql_tester.py"]
