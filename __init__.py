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

#flask-restful imports
from flask.ext.restful import Api
api = Api(app)
# api.add_resource(UserAPI, '/user/<string:user_name>')
# api.add_resource(AllUsers, '/users')

from svModule import rest
api.add_resource(rest.Users, '/users')
api.add_resource(rest.User, '/user/<int:userid>')


# initialize flask
if __name__ == '__main__':
    app.run()