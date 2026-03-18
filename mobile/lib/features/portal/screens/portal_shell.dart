import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../home/screens/home_screen.dart';
import '../../salary/screens/salary_screen.dart';
import '../../leave/screens/leave_attendance_screen.dart';
import '../../engage/screens/engage_screen.dart';
import '../../people/screens/people_screen.dart';

class PortalShell extends StatefulWidget {
  const PortalShell({super.key});

  @override
  State<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends State<PortalShell> {
  int _index = 0;

  void _openProfile() {
    context.push('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        onOpenProfile: _openProfile,
        onOpenSalary: () => setState(() => _index = 1),
        onOpenLeave: () => setState(() => _index = 2),
      ),
      SalaryScreen(onOpenProfile: _openProfile),
      LeaveAttendanceScreen(onOpenProfile: _openProfile),
      EngageScreen(onOpenProfile: _openProfile),
      PeopleScreen(onOpenProfile: _openProfile),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_rounded),
            label: 'Salary',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available_rounded),
            label: 'Leave',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_rounded),
            label: 'Engage',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_alt_rounded),
            label: 'People',
          ),
        ],
      ),
    );
  }
}
