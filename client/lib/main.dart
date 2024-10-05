import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/fetures/auth/view/pages/sign_up_page.dart';
import 'package:client/fetures/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/fetures/home/view/pages/home_page.dart';
// ignore: unused_import
import 'package:client/fetures/home/view/pages/upload_new_surah_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
    await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  final container=ProviderContainer();
  await container.read(authViewmodelProvider.notifier).initSharedPreferences();
  await container.read(authViewmodelProvider.notifier).getData();
  
 
  runApp(UncontrolledProviderScope  (
    container:container,
    child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(currentUserNotifierProvider); 
    final currentUser= ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Quraan app',
      theme: AppTheme.darkThemeMode,
      home: currentUser==null?const SignUpPage( ):const HomePage(),
    );
  }
}


