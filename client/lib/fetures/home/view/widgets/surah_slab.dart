import 'package:client/core/providers/current_surah_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/fetures/home/view/widgets/surah_player.dart';
import 'package:client/fetures/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSurah = ref.watch(currentSurahNotifierProvider);
    final surahNotifier = ref.read(currentSurahNotifierProvider.notifier);
    final userFavorite = ref
        .watch(currentUserNotifierProvider.select((data) => data!.favorites));
    if (currentSurah == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const SurahPlayer();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final tween = Tween(begin: const Offset(0, 1), end: Offset.zero).chain(
                CurveTween(
                  curve: Curves.easeIn,
                ),
              );
              final offSetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offSetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
                color: hexToColor(currentSurah.hex_code),
                borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.all(9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'surah-image',
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(currentSurah.thumbnail_url),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentSurah.surah_name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentSurah.shaikh,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppPallete.subtitleText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await ref
                              .read(homeViewmodelProvider.notifier)
                              .favSurah(surahId: currentSurah.id);
                        },
                        icon: Icon(
                            userFavorite
                                    .where((fav) =>
                                        fav.surah_id == currentSurah.id)
                                    .toList()
                                    .isNotEmpty
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: AppPallete.whiteColor)),
                    IconButton(
                        onPressed: surahNotifier.playPause,
                        icon: Icon(
                          surahNotifier.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_arrow,
                          color: AppPallete.whiteColor,
                        )),
                  ],
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: surahNotifier.audioPlayer?.positionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                final position = snapshot.data;
                final duration = surahNotifier.audioPlayer!.duration;
                double sliderValue = 0.0;
                if (position != null && duration != null) {
                  sliderValue =
                      position.inMilliseconds / duration.inMilliseconds;
                }
                return Positioned(
                  left: 8,
                  bottom: 0,
                  child: Container(
                    height: 2,
                    width:
                        sliderValue * (MediaQuery.of(context).size.width - 32),
                    decoration: BoxDecoration(
                        color: AppPallete.whiteColor,
                        borderRadius: BorderRadius.circular(7)),
                  ),
                );
              }),
          Positioned(
            left: 8,
            bottom: 0,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                  color: AppPallete.inactiveSeekColor,
                  borderRadius: BorderRadius.circular(7)),
            ),
          ),
        ],
      ),
    );
  }
}
