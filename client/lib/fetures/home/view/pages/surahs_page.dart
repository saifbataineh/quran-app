import 'package:client/core/providers/current_surah_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/fetures/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurahsPage extends ConsumerWidget {
  const SurahsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSurahs =
        ref.watch(homeViewmodelProvider.notifier).getRecentlyPlayedSurahs();
    final currentSurah = ref.watch(currentSurahNotifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSurah == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  hexToColor(currentSurah.hex_code),
                  AppPallete.transparentColor,
                ],
                stops: const [0.0,0.3]
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 36),
            child: SizedBox(
              height: 280,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: recentlyPlayedSurahs.length,
                  itemBuilder: (context, index) {
                    final surah = recentlyPlayedSurahs[index];
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(currentSurahNotifierProvider.notifier)
                            .updateSurah(surah);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppPallete.borderColor),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(surah.thumbnail_url),
                                    fit: BoxFit.cover),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                surah.surah_name,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'latest today',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ref.watch(getAllSurahsProvider).when(
              data: (surahs) {
                return SizedBox(
                  height: 260,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: surahs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(currentSurahNotifierProvider.notifier)
                                .updateSurah(surahs[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            surahs[index].thumbnail_url),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                    width: 180,
                                    child: Text(
                                      surahs[index].surah_name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )),
                                SizedBox(
                                    width: 180,
                                    child: Text(
                                      surahs[index].shaikh,
                                      style: const TextStyle(
                                          color: AppPallete.subtitleText,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ))
                              ],
                            ),
                          ),
                        );
                      }),
                );
              },
              error: (error, stacktrace) {
                return Center(
                  child: Text(error.toString()),
                );
              },
              loading: () => const Loader())
        ],
      ),
    );
  }
}
