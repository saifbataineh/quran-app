import 'package:client/core/providers/current_surah_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/fetures/home/view/pages/upload_new_surah_page.dart';
import 'package:client/fetures/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getFavSurahsProvider).when(
        data: (data) {
          return ListView.builder(
              itemCount: data.length+1,
              itemBuilder: (context, index) {
                
                if (index==data.length) {
                  return   ListTile(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UploadNewSurahPage()));
                    },
                  leading: const CircleAvatar(
                   
                    radius: 35,
                    backgroundColor: AppPallete.backgroundColor,
                    child: Icon(Icons.add),
                  ),
                  title: const Text(
                    'upload new surah',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                   
                );
                }
                final surah = data[index];
                return ListTile(
                  onTap: (){
                    ref.read(currentSurahNotifierProvider.notifier).updateSurah(surah);
                    
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(surah.thumbnail_url),
                    radius: 35,
                    backgroundColor: AppPallete.backgroundColor,
                  ),
                  title: Text(
                    surah.surah_name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    surah.shaikh,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              });
        },
        error: (error, stacktrace) {
          return Center(child: Text(error.toString()));
        },
        loading: () => const Loader());
  }
}
