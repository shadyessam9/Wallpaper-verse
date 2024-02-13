import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wallpaper_verse/pages/categories.dart';
import 'package:wallpaper_verse/pages/favorites_list.dart';
import 'package:wallpaper_verse/pages/home_page.dart';
import 'package:wallpaper_verse/pages/slideshow.dart';

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
    return PersistentTabView(
      context,
      controller: _controller,
      screens: [
        HomePage(),
        CategoriesPage(),
        FavoritesPage(),
        SlideshowPage()
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: 'Home',
          activeColorPrimary: Colors.white, // Set color non-null
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.category),
          title: 'Categories',
          activeColorPrimary: Colors.white, // Set color non-null
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.favorite),
          title: 'Favorites',
          activeColorPrimary: Colors.white, // Set color non-null
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.play_arrow),
          title: 'SlideShow',
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
    );
  }
}
