import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function(String)? onAccountSelected;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onAccountSelected,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color.fromRGBO(33, 33, 33, 1),
      actions: [
        PopupMenuButton(
          offset: Offset(0, 40),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'My Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                value: 'Profile',
              ),
              PopupMenuItem(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                value: 'logout',
              ),
            ];
          },
          icon: Icon(Icons.account_circle, color: Colors.white),
          color: Colors.grey[900],
          onSelected: onAccountSelected,
        ),
      ],
    );
  }
}
