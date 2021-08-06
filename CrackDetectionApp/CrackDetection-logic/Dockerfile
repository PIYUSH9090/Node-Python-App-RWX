# Docker will install python
FROM python:3.8

# Then data will cpoied from current to app directory
COPY . /app

# Now working directory is app 
WORKDIR /app

# Installing some useful libraries
RUN apt update -y
RUN apt install -y libgl1-mesa-glx
RUN pip3 install opencv-python
RUN pip3 install opencv-contrib-python

# Installing dependences from requirements.txt
RUN pip install -r requirements.txt

# It will run the python program on this server($PORT)
CMD python app.py runserver 0.0.0.0:5050