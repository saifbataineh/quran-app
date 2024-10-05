from sqlalchemy import TEXT, Column, ForeignKey
from models.base import Base
from sqlalchemy.orm import relationship

class Favorite (Base):
    __tablename__='favorites'  
    id=Column(TEXT,primary_key=True)
    surah_id=Column(TEXT,ForeignKey("surahs.id"))
    user_id=Column(TEXT,ForeignKey("users.id"))

    surah=relationship('Surah')
    user=relationship('User',back_populates='favorites')