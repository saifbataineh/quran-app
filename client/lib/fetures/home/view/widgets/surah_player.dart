import 'package:client/core/providers/current_surah_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/fetures/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurahPlayer extends ConsumerWidget {
  const SurahPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSurah = ref.watch(currentSurahNotifierProvider);
    final surahNotifier = ref.read(currentSurahNotifierProvider.notifier);
    final userFavorite = ref
        .watch(currentUserNotifierProvider.select((data) => data!.favorites));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            hexToColor(currentSurah!.hex_code),
            const Color(0xff121212)
          ])),
      child: Scaffold(
        backgroundColor: AppPallete.transparentColor,
        appBar: AppBar(
          backgroundColor: AppPallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: AppPallete.transparentColor,
              focusColor: AppPallete.transparentColor,
              splashColor: AppPallete.transparentColor,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: AppPallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Hero(
                  tag: 'surah-image',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(currentSurah.thumbnail_url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSurah.surah_name,
                            style: const TextStyle(
                                color: AppPallete.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            currentSurah.shaikh,
                            style: const TextStyle(
                                color: AppPallete.subtitleText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: ()
                          async{
                          await ref.read(homeViewmodelProvider.notifier).favSurah(surahId: currentSurah.id);
                        },
                        icon: Icon( userFavorite
                                    .where((fav) =>
                                        fav.surah_id == currentSurah.id)
                                    .toList()
                                    .isNotEmpty
                                ? Icons.favorite
                                : Icons.favorite_outline,)
                        
                        ,
                        color: AppPallete.whiteColor,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StreamBuilder(
                      stream: surahNotifier.audioPlayer!.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        final position = snapshot.data;
                        final duration = surahNotifier.audioPlayer!.duration;
                        double sliderValue = 0.0;
                        if (position != null && duration != null) {
                          sliderValue =
                              position.inMilliseconds / duration.inMilliseconds;
                        }
                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppPallete.whiteColor,
                                  inactiveTrackColor:
                                      AppPallete.whiteColor.withOpacity(0.117),
                                  thumbColor: AppPallete.whiteColor,
                                  trackHeight: 4,
                                  overlayShape: SliderComponentShape.noOverlay),
                              child: Slider(
                                  min: 0.0,
                                  max: 1,
                                  value: sliderValue,
                                  onChanged: (val) {
                                    sliderValue = val;
                                  },
                                  onChangeEnd: surahNotifier.seek),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  '${position?.inMinutes}:${(position!.inSeconds%60) < 10 ? '0${position.inSeconds%60}' : '${position.inSeconds%60}'}',
                                   style: const TextStyle(
                                    color: AppPallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '${duration?.inMinutes}:${(duration!.inSeconds%60) < 10 ? '0${duration.inSeconds%60}' : '${duration.inSeconds%60}'}',
                                  style: const TextStyle(
                                    color: AppPallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/shuffle.png',
                          color: AppPallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/previus-song.png',
                          color: AppPallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: surahNotifier.playPause,
                        icon: Icon(surahNotifier.isPlaying
                            ? Icons.pause_circle_outline
                            : Icons.play_circle),
                        iconSize: 80,
                        color: AppPallete.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/next-song.png',
                          color: AppPallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/repeat.png',
                          color: AppPallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/connect-device.png',
                          color: AppPallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/playlist.png',
                          color: AppPallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
