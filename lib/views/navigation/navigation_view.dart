import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MGMS/api/api.dart';
import 'package:MGMS/constants/color_constants.dart';
import 'package:MGMS/generated/locale_keys.g.dart';
import 'package:MGMS/tasks/new_task.dart';
import 'package:MGMS/views/home/home_view.dart';
import 'package:MGMS/views/settings/settings_view.dart';
import 'package:MGMS/globals/globals.dart' as globals;

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  late CupertinoTabController tabController;
  List<User> users = [];
  @override
  void initState() {
    fetchUsers().then((value) => setState(() {
      users = value;
    }));
    tabController = CupertinoTabController();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<BottomNavigationBarItem> navBarItems() {
    List<BottomNavigationBarItem> menus = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.task),
        label: 'Tasks',
      ),
    ];
    if (globals.role == "ADMINISTRATOR") {
      menus.add(BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.add), label: "New"));
      menus.add(
        BottomNavigationBarItem(
          icon: const Icon(
            CupertinoIcons.settings_solid,
          ),
          label: LocaleKeys.settings.tr(),
        ),
      );
    } else {
      menus.add(
        BottomNavigationBarItem(
          icon: const Icon(
            CupertinoIcons.settings_solid,
          ),
          label: LocaleKeys.settings.tr(),
        ),
      );
    }
    return menus;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: tabController,
      tabBar: CupertinoTabBar(
        border: const Border(),
        currentIndex: 0,
        backgroundColor: Colors.transparent,
        activeColor: CupertinoDynamicColor.withBrightness(
          color: ColorConstants.lightPrimaryIcon,
          darkColor: ColorConstants.darkPrimaryIcon,
        ),
        inactiveColor: CupertinoDynamicColor.withBrightness(
          color: ColorConstants.lightInactive,
          darkColor: ColorConstants.darkInactive,
        ),
        items: navBarItems(),
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return const HomeView();
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                if (globals.role == "ADMINISTRATOR") {
                  return NewTask(users: users,);
                } else {
                  return const SettingsView();
                }
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return const SettingsView();
              },
            );
          default:
            tabController.index = 0;
            return const HomeView();
        }
      },
    );
  }
}
