import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session
from database import get_db

import cloudinary
import cloudinary.uploader

from middleware.auth_middleware import auth_middleware
from models.favorite import Favorite
from models.surah import Surah
from pydantic_schemas.favorite_surah import FavoriteSurah
from sqlalchemy.orm import joinedload

router=APIRouter()
# Configuration       
cloudinary.config( 
    cloud_name = "devdwfdqf", 
    api_key = "726954229978135", 
    api_secret = "okA391dWjgzMmfaVLU4l5L_AVAA", # Click 'View API Keys' above to copy your API secret
    secure=True
)
@router.post('/upload',status_code=201)
def upload_surah(surah:UploadFile=File(...),
                 thumbnail:UploadFile=File(...),
                 shaikh:str=Form(...),
                 surah_name:str=Form(...),
                 hex_code:str=Form(...),
                 db:Session=Depends(get_db),
                 
                 auth_dict=Depends(auth_middleware)
                 ):
    surah_id=str(uuid.uuid4())
    surah_res=cloudinary.uploader.upload(surah.file,resource_type='auto',folder=f'surahs/{surah_id}')
    
    thumbnail_res=cloudinary.uploader.upload(thumbnail.file,resource_type='image',folder=f'surahs/{surah_id}')
    
    print(surah_id)
    print(surah_name)
    print(shaikh)
    print(hex_code)
    print(surah_res['url'])
    print(thumbnail_res['url'])

    new_surah=Surah(
        id=surah_id,
        surah_name=surah_name,
        shaikh=shaikh,
        hex_code=hex_code,
        surah_url=surah_res['url'],
        thumbnail_url=thumbnail_res['url']
)
    db.add(new_surah)
    db.commit()
    db.refresh(new_surah)
    return new_surah

@router.get('/list')
def listSurahs(db:Session=Depends(get_db),auth_details=Depends(auth_middleware)):
    surahs= db.query(Surah).all()
    return surahs

@router.post('/favorite')
def favorite_song(surah: FavoriteSurah, db: Session = Depends(get_db), auth_details = Depends(auth_middleware)):
    
    # Get the current user's ID
    user_id = auth_details['uid']
    
    # Check if the song is already favorited by the user
    fav_surah = db.query(Favorite).filter(Favorite.surah_id == surah.surah_id, Favorite.user_id == user_id).first()
    
    if fav_surah:
        # If the surah is already favorited, remove it (unfavorite)
        db.delete(fav_surah)
        db.commit()
        return {'message': False}
    else:
        # If not favorited, add it to the user's favorites
        new_fav = Favorite(id=str(uuid.uuid4()), surah_id=surah.surah_id, user_id=user_id)
        db.add(new_fav)
        db.commit()
        return {'message': True}
    
@router.get('/list/favorites')
def list_fav_Surahs(db:Session=Depends(get_db),auth_details=Depends(auth_middleware)):
    user_id=auth_details['uid']
    fav_surahs=db.query(Favorite).filter(Favorite.user_id == user_id).options(
        joinedload(Favorite.surah)
    ).all()
    
    return fav_surahs