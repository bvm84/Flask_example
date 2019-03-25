from flask_restful import Api, Resource

api = Api()


class Test(Resource):
    @staticmethod
    def get():
        return {'api_token': 'sucess'}


api.add_resource(Test, '/api/test')
