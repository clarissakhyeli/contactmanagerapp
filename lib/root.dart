import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/navigation_provider.dart';

class Root extends StatelessWidget {
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        final bottomNavigationBarItems = provider.screens
            .map((screen) => BottomNavigationBarItem(
          backgroundColor: Colors.blueGrey,
          icon: Icon(screen.iconData), title: Text(screen.title),
        )
        )
            .toList();

        final screens = provider.screens
            .map(
              (screen) => Offstage(
            offstage: screen != provider.currentScreen,
            child: Navigator(
              key: screen.navigatorState,
              onGenerateRoute: screen.onGenerateRoute,
            ),
          ),
        )
            .toList();

        return WillPopScope(
          onWillPop: provider.onWillPop,
          child: Scaffold(
            body: IndexedStack(
              children: screens,
              index: provider.currentTabIndex,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: bottomNavigationBarItems,
              currentIndex: provider.currentTabIndex,
              onTap: provider.setTab,
            ),
          ),
        );
      },
    );
  }
}
