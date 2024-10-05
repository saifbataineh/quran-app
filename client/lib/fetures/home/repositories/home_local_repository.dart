import 'package:client/fetures/home/model/surah_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref){
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box=Hive.box();
  void uploadLocalSurah(SurahModel surah){
box.put(surah.id, surah.toJson());

  }
  List<SurahModel>loadSurahs(){
List<SurahModel> surahs=[];
for(final key in box.keys){
  surahs.add( SurahModel.fromJson(box.get(key)));
}
return surahs;
 
  }
}