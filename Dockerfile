FROM python:2.7.16-alpine3.9

WORKDIR /app

RUN mkdir templates
COPY hello.html templates/
COPY mysql-tester.py .
COPY requirements.txt .

RUN pip install --upgrade pip && pip install --trusted-host pypi.python.org -r requirements.txt

ENV FLASK_APP mysql-tester.py

CMD ["python", "mysql-tester.py"]
