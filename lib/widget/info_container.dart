import 'package:flutter/material.dart';

class MyInfoContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const MyInfoContainer({Key? key, required this.title, required this.subtitle, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.5,
                      wordSpacing: 2),
                ),
                Text(subtitle, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
            const SizedBox(width: 20),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
