import os
from dotenv import load_dotenv


basedir = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(basedir, '.env'))


class Config:
    SECRET_KEY = 'SjdnUends256Jsdlkvxh987ksdODnejdDq'
    SEND_FILE_MAX_AGE_DEFAULT = 1
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or 'sqlite:///' + os.path.join(basedir, 'app.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    GRAPH_IMAGE_NAME = os.getcwd() + '/app/static/images/graph.png'
