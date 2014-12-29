from sqlalchemy import Column, String, Integer, ForeignKey, Sequence, DateTime, Boolean
from sqlalchemy.dialects.postgresql import BIT, UUID, TEXT
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.declarative import declarative_base
from geoalchemy2 import Geometry



class User(Base):
    __tablename__ = 'TUSER'
    userid = Column(Integer , primary_key = True)
    email = Column(String)
    name = Column(String)
    pwdhash = Column(String)
    verified = Column(Boolean)
    creation_date = Column(DateTime(True))

class Device(Base):
    __tablename__ = 'MYDEVICE'
    deviceid = Column(Integer, primary_key=True)
    device_uuid = Column(UUID)
    model = Column ( String(100))
    cordova = Column( String(100))
    platform = Column( String(100))
    version = Column( String(100))
    name = Column( String(100))
    userid = Column( Integer)
    current = Column( BIT)
    creation_date = Column( DateTime(True))

class Resource(Base):
    __tablename__ = "RESOURCE"
    resourceid = Column( Integer, primary_key = True)
    type = Column( String(50) )
    filepath = Column( TEXT )
    creation_date = Column( DateTime(True))
    deviceid = Column( UUID, ForeignKey("MYDEVICE.deviceid")  )
    geom = Column(Geometry('POINT', 4326))