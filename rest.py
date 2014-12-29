from flask import request
#from flask.ext.restful import reqparse, abort, Api, Resource
from flask.ext.restful import Resource, fields, marshal_with, reqparse, marshal

from svModule import database

#fields, marshal_with

user_fields = {
    'userid' : fields.Integer,
    'email' : fields.String,
    'name' : fields.String,
    'pwdhash' : fields.String,
    'verified' : fields.Boolean,
    'creation_date' : fields.DateTime
}

device_fields = {
    'deviceid' : fields.String, #Column(UUID, primary_key=True)
    'model' : fields.String, #Column ( String(100))
    'cordova' : fields.String, #Column( String(100))
    'platform' : fields.String, #Column( String(100))
    'version' : fields.String, #Column( String(100))
    'name' : fields.String, #Column( String(100))
    'userid' : fields.Integer, #Column( Integer)
    'current' : fields.Boolean, #Column( BIT)
    'creation_date' : fields.DateTime, #Column( DateTime(True))
}

class Users(Resource):
    @marshal_with(user_fields)
    def get(self):
        return database.scope. \
        query(database.User).all()

    def post(self):
        try:
            p = reqparse.RequestParser()
            p.add_argument('email', type=str)
            p.add_argument('name', type=str)
            args = p.parse_args()
            #user = database.User(name = args.name, email = args.email)
            postUser = database.User()
            postUser.name = args.name
            postUser.email = args.email
            # print user
            database.scope.add(postUser)
            database.scope.commit()
        except Exception, e:
            database.scope.rollback()
            #raise e
        finally:
            #database.scope.close()
            pass
        return marshal(postUser, user_fields)
        

class User(Resource):
    @marshal_with(user_fields)
    def get(self, userid):
        return database.scope. \
        query(database.User). \
        filter(database.User.userid == userid).first()

class Devices(Resource):
    @marshal_with(device_fields)
    def get(self):
        return database.scope. \
        query(database.Device).all()

