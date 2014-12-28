from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from svModule import app
from svModule.dbModels import *
#engine = create_engine('postgresql://tester:tester@localhost/svModule')
engine = create_engine(app.config["SQLALCHEMY_CONNECTION"])
Session = sessionmaker(bind=engine)
scope = Session()
