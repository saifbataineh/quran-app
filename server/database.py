from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL='postgresql://postgres:123123@localhost:5432/quranapp'
engine=create_engine(DATABASE_URL)
sessionLocal= sessionmaker(autocommit=False,autoflush=False,bind=engine)
def get_db():
    db=sessionLocal()
    try:
        yield db
    finally:
        db.close()
        