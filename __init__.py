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
import geoalchemy2.functions as geofunc
import json


class User(db.Model):
    __tablename__ = 'TUSER'
    userid = db.Column( db.Integer , primary_key = True)
    email = db.Column(db.String, unique=True)
    name = db.Column(db.String)
    pwdhash = db.Column(db.String)
    verified = db.Column(db.Boolean)
    creation_date = db.Column(db.DateTime(True))

class Device(db.Model):
    __tablename__ = 'DEVICE'
    deviceid = db.Column(Integer, primary_key=True)
    device_uuid = db.Column(UUID, primary_key=True)
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
    resource_type = db.Column("type", db.String(50))
    filepath = db.Column( TEXT )
    creation_date = db.Column( db.DateTime(True))
    deviceid = db.Column( Integer, ForeignKey("DEVICE.deviceid"))
    #owner = db.relationship('User', backref=db.backref('devices', lazy='dynamic'))    
    # geom = Column(Geometry('POINT', 4326))
    #geom = Column(Geometry(geometry_type='POINT', srid=4326))
    geom = Column(Geometry)
    def resource(self):
        g = json.loads(db.session.scalar(geofunc.ST_AsGeoJSON(self.geom, 15, 2)))
        attrs = db.session.query(Attribute).filter(Attribute.resourceid == self.resourceid).all()
        props = {}
        for attr in attrs:
            props[attr.label] = attr.value
        incude_prop = ['filepath', 'creation_date', 'resource_type']
        for p in incude_prop:
            props[p] = getattr(self, p, None)
        g["properties"] = props
        return g

class Attribute(db.Model):
    __tablename__ = "ATTRIBUTES"
    attributeid = db.Column(db.Integer, primary_key=True)
    label = db.Column(db.String(300))
    value = db.Column(db.String(500))
    resourceid = db.Column(db.Integer, ForeignKey("RESOURCE.resourceid"))
    # resource = db.relationship("Resource", backref=db.backref('atributes', lazy='dynamic'))
    resouce =db.relationship('Resource', backref=db.backref('resources', lazy='dynamic'))



#db.create_all()
#####
# Create the Flask-Restless API manager.
manager = flask.ext.restless.APIManager(app, flask_sqlalchemy_db=db)

# Create API endpoints, which will be available at /api/<tablename> by
# default. Allowed HTTP methods can be specified as well.
manager.create_api(User, collection_name='user', methods=['GET', 'POST', 'DELETE', 'PUT'])
manager.create_api(Device, collection_name='device', methods=['GET', 'POST'], primary_key='device_uuid')
manager.create_api(Resource, collection_name='resource', methods=['GET', 'POST'], include_methods = ['resource'], exclude_columns=['geom', 'filepath', 'creation_date', 'type'])
manager.create_api(Attribute, collection_name='attribute', methods=['POST'])

def add_cors_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    # Set whatever other headers you like...
    return response


# initialize flask
if __name__ == '__main__':
    app.run()