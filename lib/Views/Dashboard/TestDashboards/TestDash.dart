import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:house_maid_project/Views/Chats/chatsList.dart";
import "package:house_maid_project/Views/Dashboard/TestDashboards/homeTab.dart";
import "package:house_maid_project/Views/Dashboard/TestDashboards/profileTab.dart";
import "package:house_maid_project/Views/Tasks/taskTab.dart";
import "package:house_maid_project/Views/login/loginScreen.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

class TestDashboard extends StatelessWidget {
  const TestDashboard({super.key});

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: HouseMaidDashboardTab(),
          item: ItemConfig(
            activeForegroundColor: Colors.white,
            inactiveBackgroundColor: Colors.white,
            inactiveForegroundColor: Colors.black,
            icon: const Icon(Icons.home),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: TasksScreenTab(),
          item: ItemConfig(
            activeForegroundColor: Colors.white,
            inactiveBackgroundColor: const Color.fromARGB(255, 4, 4, 4),
            inactiveForegroundColor: Colors.black,
            icon: const Icon(Icons.schedule),
            title: "Tasks",
          ),
        ),
        PersistentTabConfig(
          screen: ChatListScreen(
            currentUserId: '1',
            isHousemaid: true,
          ),
          item: ItemConfig(
            activeForegroundColor: Colors.white,
            inactiveBackgroundColor: const Color.fromARGB(255, 4, 4, 4),
            inactiveForegroundColor: Colors.black,
            icon: const Icon(Icons.chat),
            title: "Chats",
          ),
        ),
        PersistentTabConfig(
          screen: ProfileTabScreen(),
          item: ItemConfig(
            activeForegroundColor: Colors.white,
            inactiveForegroundColor: Colors.black,
            inactiveBackgroundColor: const Color.fromARGB(255, 4, 4, 4),
            icon: const Icon(Icons.person),
            title: "Profile",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => PersistentTabView(
        margin: EdgeInsets.all(8),
        backgroundColor: Color.fromARGB(255, 254, 176, 217),
        tabs: _tabs(),
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(color: Colors.transparent),
        ),
        navBarOverlap: NavBarOverlap.full(),
      );
}
