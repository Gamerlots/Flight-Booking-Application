import json
import os
from flask import *
import pymongo

uri = "mongodb+srv://aarinDave:DBEfHhdueTi2N7q7@mongodb.6iicfiw.mongodb.net/?retryWrites=true&w=majority"
client = pymongo.MongoClient(uri, tls=True, tlsAllowInvalidCertificates=True)
database = client["flight-booking-application"]

app = Flask(__name__)


@app.route("/")
def home():
    return "Welcome to the Flight Booking Application!"


@app.route("/api/add-user/", methods=("GET", "POST"))
def add_user():
    response = Response()
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Credentials", True)
    response.headers.add("Access-Control-Allow-Headers", "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale")
    response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS")

    email = request.json["email"]
    password = request.json["password"]

    document = database.users.find_one({"email": email})
    if document == None:
        database.users.insert_one({"email": email, "password": password, "bookings": []})
        response.data = "SUCCESS"
        return response
    
    response.data = "USER_DOES_EXIST"
    return response


@app.route("/api/verify-user/", methods=("GET", "POST"))
def verify_user():
    response = Response()
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Credentials", True)
    response.headers.add("Access-Control-Allow-Headers", "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale")
    response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS")
    
    email = request.json["email"]
    password = request.json["password"]


    document = database.users.find_one({"email": email})
    if document == None:
        response.data = "USER_DOES_NOT_EXIST"
        return response
    
    is_password_matched = document["password"] == password
    if is_password_matched:
        response.data = "SUCCESS"
        return response
    
    response.data = "WRONG_PASSWORD"
    return response


@app.route("/api/add-booking/", methods=("GET", "POST"))
def add_booking():
    response = Response()
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Credentials", True)
    response.headers.add("Access-Control-Allow-Headers", "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale")
    response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS")

    email = request.json["email"]
    booking_information = request.json["bookingInformation"]

    document = database.users.find_one({"email": email})
    if document == None:
        response.data = "USER_DOES_NOT_EXIST"
        return response
    
    bookings = document["bookings"]
    bookings.append(booking_information)
    database.users.update_one({"email": email}, {"$set": {"bookings": bookings}})

    response.data = "SUCCESS"
    return response


@app.route("/api/get-bookings/", methods=("GET", "POST"))
def get_bookings():
    response = Response()
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Credentials", True)
    response.headers.add("Access-Control-Allow-Headers", "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale")
    response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS")

    email = request.json["email"]

    document = database.users.find_one({"email": email})
    if document == None:
        response.data = "USER_DOES_NOT_EXIST"
        return response

    response.data = json.dumps(document["bookings"])
    return response


if __name__ == "__main__":
    app.run(debug=True)
