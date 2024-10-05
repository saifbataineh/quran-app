
from fastapi import FastAPI, HTTPException
from database import engine
from models.base import Base
from routes import auth, quraan

app=FastAPI()
app.include_router(auth.router,prefix='/auth')
app.include_router(quraan.router,prefix='/quraan')



Base.metadata.create_all(engine)