import 'package:client/fetures/home/model/surah_model.dart';
import 'package:client/fetures/home/repositories/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_surah_notifier.g.dart';
@riverpod
class CurrentSurahNotifier extends _$CurrentSurahNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying=false;
  @override
  SurahModel? build(){
    _homeLocalRepository=ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSurah(SurahModel surah)async{
    await audioPlayer?.stop();
    audioPlayer=AudioPlayer();
    final audioSource =AudioSource.uri(Uri.parse(surah.surah_url,
    ),
    tag:MediaItem(id: surah.id, title: surah.surah_name,artist: surah.shaikh,
    artUri: Uri.parse(surah.thumbnail_url))
    );
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.playerStateStream.listen((state){
      if(state.processingState==ProcessingState.completed){
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying=false;
      this.state=this.state?.copyWith(hex_code:this.state?.hex_code);
      }
    });
    
    
    _homeLocalRepository.uploadLocalSurah(surah);
 audioPlayer!.play();
 isPlaying=true;
state=surah;
  }

  void playPause(){
    if(isPlaying){
      audioPlayer?.pause();
    }
    else{
      audioPlayer?.play();
    }
    isPlaying=!isPlaying;
    state=state?.copyWith(hex_code:state?.hex_code);
  }
  void seek(double val){
    audioPlayer!.seek(Duration(milliseconds:  (val*audioPlayer!.duration!.inMilliseconds).toInt())
  );}
}