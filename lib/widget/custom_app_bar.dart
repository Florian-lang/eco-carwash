import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String name;

  const CustomAppBar({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(name, style:TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      backgroundColor: Theme.of(context).colorScheme.primary
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}