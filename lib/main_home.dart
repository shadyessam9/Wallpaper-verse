import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wallpaper_verse/pages/dialpad_ios.dart';
import 'package:wallpaper_verse/pages/favorites.dart';
import 'package:wallpaper_verse/pages/home.dart';
import 'package:wallpaper_verse/pages/slideshow.dart';
import 'package:wallpaper_verse/pages/studio.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        MediaQueryData mediaQuery = MediaQuery.of(context);
        EdgeInsets viewInsets = mediaQuery.viewInsets;

        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: PersistentTabView(
            context,
            controller: _controller,
            screens: [
              HomePage(),
              FavoritesPage(),
              StudioPage(),
              SlideshowPage(),
              DialPadIos()
            ],
            items: [
              PersistentBottomNavBarItem(
                icon: Icon(Icons.home),
                title: 'Home',
                activeColorPrimary: Colors.white, // Set color non-null
              ),
              PersistentBottomNavBarItem(
                icon: Icon(Icons.favorite),
                title: 'My Favorites',
                activeColorPrimary: Colors.white, // Set color non-null
              ),
              PersistentBottomNavBarItem(
                icon: Icon(Icons.image_sharp),
                title: 'My Studio',
                activeColorPrimary: Colors.white, // Set color non-null
              ),
              PersistentBottomNavBarItem(
                icon: Icon(Icons.settings),
                title: 'Slide Show',
                activeColorPrimary: Colors.white, // Set color non-null
              ),
              PersistentBottomNavBarItem(
                icon: Icon(Icons.call),
                title: 'DialPad',
                activeColorPrimary: Colors.white, // Set color non-null
              )
            ],
            confineInSafeArea: true,
            backgroundColor: Color.fromRGBO(33, 33, 33, 1), // Dark Grey Color
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardShows: true,
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(5),
              colorBehindNavBar: Color.fromRGBO(33, 33, 33, 1),
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties(
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.style1,
          ),
        );
      },
    );
  }
}
