 import 'package:client/core/theme/app_pallete.dart';
import 'package:client/fetures/home/view/pages/library_page.dart';
import 'package:client/fetures/home/view/pages/surahs_page.dart';
import 'package:client/fetures/home/view/widgets/surah_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
 
   static MaterialPageRoute route(){
    return MaterialPageRoute(builder: (cotext)=>const HomePage());
  }
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
   int selectedIndex=0; 
   final pages=[
    const SurahsPage(),
    const LibraryPage(),
   ];
@override
  Widget build(BuildContext context) {
  
    return  Scaffold(
      body: Stack(

        children: [
          pages[selectedIndex],
          const Positioned(
            bottom: 0,
            child: MusicSlab())
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value){
          setState(() {
            selectedIndex=value;
          });
        },
items: [
  BottomNavigationBarItem(
    label: 'Home'
    ,icon: 
    Image.asset(selectedIndex==0?'assets/images/home_filled.png':'assets/images/home_unfilled.png',color: selectedIndex==0?AppPallete.whiteColor:AppPallete.inactiveBottomeBarColor,)),
  BottomNavigationBarItem(
    label: 'Library',
    icon: Image.asset('assets/images/library.png',color: selectedIndex==1?AppPallete.whiteColor:AppPallete.inactiveBottomeBarColor,)),

],

      ),
    );
  }
}