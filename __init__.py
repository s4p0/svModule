# inner module import
# imports from our models.py
#from models import UserAPI, AllUsers

# import flask class
from flask import Flask
# main flask app
app = Flask(__name__)
# load settings from config.py
app.config.from_pyfile('configure.py')
# ensure is loaded
print app.config['DEBUG']
print app.config['SQLALCHEMY_DATABASE_URI']

#flask-restful imports
# from flask.ext.restful import Api
# api = Api(app)
# api.add_resource(UserAPI, '/user/<string:user_name>')
# api.add_resource(AllUsers, '/users')

# from svModule import rest
# api.add_resource(rest.Users, '/users')
# api.add_resource(rest.User, '/user/<int:userid>')

###
#add database instance
import flask.ext.sqlalchemy
import flask.ext.restless
db = flask.ext.sqlalchemy.SQLAlchemy(app)



#####
from sqlalchemy import Column, String, Integer, ForeignKey, Sequence, DateTime, Boolean
from sqlalchemy.dialects.postgresql import BIT, UUID, TEXT
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.declarative import declarative_base
from geoalchemy2 import Geometry



class User(db.Model):
    __tablename__ = 'TUSER'
    userid = db.Column( db.Integer , primary_key = True)
    email = db.Column(db.String, unique=True)
    name = db.Column(db.String)
    pwdhash = db.Column(db.String)
    verified = db.Column(db.Boolean)
    creation_date = db.Column(db.DateTime(True))

class Device(db.Model):
    __tablename__ = 'MYDEVICE'
    deviceid = db.Column(Integer, primary_key=True)
    device_uuid = db.Column(UUID)
    model = db.Column ( db.String(100))
    cordova = db.Column( db.String(100))
    platform = db.Column( db.String(100))
    version = db.Column( db.String(100))
    name = db.Column( db.String(100))
    userid = db.Column( db.Integer, ForeignKey("TUSER.userid")  )
    current = db.Column( BIT)
    creation_date = db.Column( db.DateTime(True))
    owner = db.relationship('User', backref=db.backref('devices', lazy='dynamic'))

class Resource(db.Model):
    __tablename__ = "RESOURCE"
    resourceid = db.Column( db.Integer, primary_key = True)
    type = db.Column( db.String(50) )
    filepath = db.Column( TEXT )
    creation_date = db.Column( db.DateTime(True))
    deviceid = db.Column( Integer, ForeignKey("MYDEVICE.deviceid")  )
    # geom = Column(Geometry('POINT', 4326))
db.create_all()
#####
# Create the Flask-Restless API manager.
manager = flask.ext.restless.APIManager(app, flask_sqlalchemy_db=db)

# Create API endpoints, which will be available at /api/<tablename> by
# default. Allowed HTTP methods can be specified as well.
manager.create_api(User, collection_name='user', methods=['GET', 'POST', 'DELETE', 'PUT'])
manager.create_api(Device, collection_name='device', methods=['GET', 'POST'])

def add_cors_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    # Set whatever other headers you like...
    return response


# initialize flask
if __name__ == '__main__':
    app.run()