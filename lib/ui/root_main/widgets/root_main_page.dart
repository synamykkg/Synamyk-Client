import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/ui/core/ui/widgets/custom_bottom_navigation_bar.dart';

class RootMainPage extends StatelessWidget {
  const RootMainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      bottomNavigationBar: CustomBottomNavigationBar(
        navigationShell: navigationShell,
      ),
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      //   title: Text('Synamyk'),
      // ),
      body: navigationShell,
    );
  }
}
