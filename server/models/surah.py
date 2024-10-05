from sqlalchemy import TEXT, VARCHAR, Column
from models.base import Base


class Surah(Base):
    __tablename__='surahs'

    id=Column(TEXT,primary_key=True)
    surah_url=Column(TEXT)
    thumbnail_url=Column(TEXT)
    shaikh=Column(TEXT)
    surah_name=Column(VARCHAR(100))
    hex_code=Column(VARCHAR(6))