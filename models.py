##resources :
##-- pictures
##    - GET  => LIST ALL
##    - POST => CREATE NEW
##    - picture/uid
##        -GET => RETURN PICTURES[UID]
##        -POST => NOT ALLOWED
##        -PUT => UPDATE PICTURES[UID]
##        -DELETE => DELETE PICTURES[UID]
##
##-- videos
##    - GET  => LIST ALL
##    - POST => CREATE NEW
##    - video/uid
##        -GET => RETURN VIDEOS[UID]
##        -POST => NOT ALLOWED
##        -PUT => UPDATE VIDEOS[UID]
##        -DELETE => DELETE VIDEOS[UID]
##
##-- audios
##    - GET   => LIST ALL
##    - POST => CREATE NEW
##    -audio/uid
##        -GET => RETURN AUDIO[UID]
##        -POST => NOT ALLOWED
##        -PUT => UPDATE AUDIO[UID]
##        -DELETE => DELETE AUDIO[UID]






from flask import request
from flask.ext.restful import reqparse, abort, Api, Resource

users = {}

parser = reqparse.RequestParser()
parser.add_argument('user', type=str)

class UserAPI(Resource):
    def get(self, user_name):
        return {user_name: users[user_name]}

    def put(self, user_name):
        users[user_name] = request.form['data']
        return {user_name: users[user_name]}

    def delete(self, id):
        pass

class AllUsers(Resource):
    def get(self):
        return users

    def post(self):
        args = parser.parse_args()
        user_id = 'user%d' % (len(users) + 1)
        users[user_id] = {'user': args['user']}
        return users[user_id], 201
        