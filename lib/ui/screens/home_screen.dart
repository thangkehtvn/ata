import 'package:ata/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ata/ui/screens/check_in_screen.dart';
import 'package:ata/core/services/auth_service.dart';
import 'package:ata/ui/screens/report_screen.dart';
import 'package:ata/ui/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, Object>> _tabs;
  List<Widget> pages = [CheckInScreen(), ReportScreen(), SettingsScreen()];
  int _selectedTabIndex = 0;
  PageController _pageController;
  bool isSwipeTab;
  // int _page = 0;
  @override
  void initState() {
    super.initState();
    _tabs = [
      {
        'tab': CheckInScreen(),
        'title': Text('Check In/Out'),
        'icon': Icon(Icons.playlist_add_check),
      },
      {
        'tab': ReportScreen(),
        'title': Text('Reports'),
        'icon': Icon(Icons.chrome_reader_mode),
      },
      {
        'tab': SettingsScreen(),
        'title': Text('Settings'),
        'icon': Icon(Icons.settings),
      },
    ];
    _pageController = new PageController();
    isSwipeTab = false;
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  //Animates the controlled [PageView] from the current page to the given page.
  void _navigateToPage(int index) {
    _pageController.animateToPage(index,duration: Duration(milliseconds: 100), curve: Curves.ease);
  }

  void _changeTab(int index) {
    setState(() {
      this._selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var selectedTab = _tabs[_selectedTabIndex];
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Tracking'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await Provider.of<AuthService>(context, listen: false).signOut();
                Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
              },
            ),
          ],
        ),
        body: isSwipeTab
            ? selectedTab['tab']
            : PageView(
                children: pages,
                controller: _pageController,
                onPageChanged: _changeTab,
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: _navigateToPage,
          items: _tabs
              .map((tab) => BottomNavigationBarItem(
                    icon: tab['icon'],
                    title: tab['title'],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
