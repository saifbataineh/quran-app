import 'dart:convert';
import 'dart:io';


import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/fetures/home/model/surah_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSurah({
    required File selectedAudio,
    required File selectedThumbNail,
    required String surahName,
    required String shaikh,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
          "POST", Uri.parse('${ServerConstants.serverUrl}quraan/upload'));
      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath('surah', selectedAudio.path),
            await http.MultipartFile.fromPath(
                'thumbnail', selectedThumbNail.path)
          ],
        )
        ..fields.addAll(
          {'shaikh': shaikh, 'surah_name': surahName, 'hex_code': hexCode},
        )
        ..headers.addAll(
          {'x-auth-token': token},
        );
      final res = await request.send();
      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SurahModel>>> getAllSurahs({
    required String token,
  }) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstants.serverUrl}quraan/list'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });
      var resBodyMap=jsonDecode(res.body) ;
      if(res.statusCode!=200){
        resBodyMap=resBodyMap as Map<String,dynamic>;
        

        return Left(AppFailure(resBodyMap['detail']));
      }

      resBodyMap=resBodyMap as List;
      List<SurahModel> surahs=[]; 
      for (final map in resBodyMap){
        surahs.add(SurahModel.fromMap(map));
        
      }
      return Right(surahs); 

    } catch (e) {
      return Left(AppFailure(e.toString()));
    }

  }
  Future<Either<AppFailure, bool>> favSurahs({
    required String token,
    required String surahId,
  }) async {
    try {
      final res = await http
          .post(Uri.parse('${ServerConstants.serverUrl}quraan/favorite'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: jsonEncode(
        {

        "surah_id":surahId
        }
        ));
      var resBodyMap=jsonDecode(res.body) ;
      if(res.statusCode!=200){
        resBodyMap=resBodyMap as Map<String,dynamic>;
        

        return Left(AppFailure(resBodyMap['detail']));
      }

   
      return Right(resBodyMap['message']); 

    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
   Future<Either<AppFailure, List<SurahModel>>> getFavSurahs({
    required String token,
  }) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstants.serverUrl}quraan/list/favorites'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },);
      var resBodyMap=jsonDecode(res.body) ;
      if(res.statusCode!=200){
        resBodyMap=resBodyMap as Map<String,dynamic>;
        

        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap=resBodyMap as List;
      List<SurahModel> surahs=[]; 
      for (final map in resBodyMap){
        surahs.add(SurahModel.fromMap(map['surah']));
        
      }
      return Right(surahs); 

    } catch (e) {
      return Left(AppFailure(e.toString()));
    }

  }
}
  


