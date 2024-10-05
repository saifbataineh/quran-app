import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header
import jwt

from database import get_db
from middleware.auth_middleware import auth_middleware
from models.favorite import Favorite
from models.user import User
from pydantic_schemas.user_create import userCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session
from sqlalchemy.orm import joinedload
from pydantic_schemas.user_login import UserLogin

router=APIRouter()


@router.post('/signup',status_code=201)
def signup_user(user:userCreate,db:Session=Depends(get_db)):
    print("heelllooo")
    #check if user already exists in db
    user_db = db.query(User).filter(User.email == user.email).first()
    if  user_db:
        raise HTTPException(400,'user with the same email already exists!') 
    hased_pw=bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    user_db=User(id=str(uuid.uuid4()),email=user.email,password=hased_pw,name=user.name)

    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db

@router.post('/login')
def login_user(user:UserLogin,db:Session=Depends(get_db)):
    
    #check if a user with the same email already exists
    user_db=db.query(User).filter(User.email==user.email).first()
    print(user_db)
    if not user_db:
         raise HTTPException(400,'User with this email does not exist!')
    #password matching
    is_match=bcrypt.checkpw(user.password.encode(),user_db.password)
    print(is_match)
    print(user_db)
    
    if not is_match:
        raise HTTPException(400,'Incorrect password!')
    token=jwt.encode({
        'id':user_db.id,

    },'password_key')
    return {'token':token,'user':user_db}

@router.get('/')
def current_user_data(db:Session=Depends(get_db),user_dict=Depends(auth_middleware)):
    user=db.query(User).filter(User.id==user_dict['uid']).options(
        joinedload(User.favorites)
    ).first()
    if not user:
        raise HTTPException(404,'User not found')
    return user

    