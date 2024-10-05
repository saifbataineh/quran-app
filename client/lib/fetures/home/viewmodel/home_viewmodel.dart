import 'dart:io';
import 'dart:ui';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/fetures/home/model/favorite_surah_model.dart';
import 'package:client/fetures/home/model/surah_model.dart';
import 'package:client/fetures/home/repositories/home_local_repository.dart';
import 'package:client/fetures/home/repositories/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SurahModel>> getAllSurahs(GetAllSurahsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider.select((user)=>user!.token));
  final res = await ref
      .watch(homeRepositoryProvider)
      .getAllSurahs(token: token);

return switch(res){
  Left(value:final l)=>throw  l.message, 
  Right(value:final r)=>r,
};
}
@riverpod
Future<List<SurahModel>> getFavSurahs(GetFavSurahsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider.select((user)=>user!.token));
  final res = await ref
      .watch(homeRepositoryProvider)
      .getFavSurahs(token: token);

return switch(res){
  Left(value:final l)=>throw  l.message, 
  Right(value:final r)=>r,
};
}
@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository=ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSurah(
      {required File selectedAudio,
      required File selectedThumbNail,
      required String surahName,
      required String shaikh,
      required Color selectedColor}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSurah(
      selectedAudio: selectedAudio,
      selectedThumbNail: selectedThumbNail,
      surahName: surahName,
      shaikh: shaikh,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );
    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r)
    };
  }
  List<SurahModel> getRecentlyPlayedSurahs(){
return _homeLocalRepository.loadSurahs();
  }
    Future<void> favSurah(
      {required surahId}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSurahs(
      surahId: surahId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );
    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) =>_favSurahSuccess(r, surahId) ,
    };
  }
  AsyncValue _favSurahSuccess(bool isFavorited,String surahId){
    final  userNotifier=ref.read(currentUserNotifierProvider.notifier);
    if(isFavorited){
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(favorites: [
          ...ref.read(currentUserNotifierProvider)!.favorites,
          FavoriteSurahModel(id: '',surah_id: surahId,user_id: '')
        ])
      );
    }else{
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favorites: ref.read(currentUserNotifierProvider)!.favorites.where((fav)=>fav.surah_id!=surahId,).toList(),
      ));
    }
    ref.invalidate(getFavSurahsProvider);
    return state = AsyncValue.data(isFavorited);
  }
}
