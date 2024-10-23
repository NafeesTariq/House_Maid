import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:house_maid_project/Views/Tasks/TaskDetails.dart';

class TasksScreenTab extends StatefulWidget {
  @override
  _TasksScreenTabState createState() => _TasksScreenTabState();
}

class _TasksScreenTabState extends State<TasksScreenTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTaskCard(String taskerName, String dateTime, String tasksDetail,
      String amount, String status, Color statusColor) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(
                  'assets/images/profile_image.png'), // Replace with your image asset
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskerName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateTime,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tasksDetail,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Amount: \$ $amount',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
                const SizedBox(height: 16),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(
            'Tasks',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.pinkAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.pinkAccent,
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Past(3)'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Current tasks
            ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Today',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the Task Details Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetailsScreen()),
                    );
                  },
                  child: _buildTaskCard(
                    'Tasker Name',
                    '16 September, 2024 - 5:30 pm',
                    '3 rooms - 15 tasks',
                    '100.00',
                    'Require Action',
                    Colors.orange,
                  ),
                ),
                _buildTaskCard(
                    'Tasker Name',
                    '16 September, 2024 - 5:30 pm',
                    '3 rooms - 15 tasks',
                    '100.00',
                    'In Progress',
                    Colors.pinkAccent),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Yesterday',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                _buildTaskCard(
                    'Tasker Name',
                    '16 September, 2024 - 5:30 pm',
                    '3 rooms - 15 tasks',
                    '100.00',
                    'Complete',
                    Colors.blueGrey),
                _buildTaskCard(
                    'Tasker Name',
                    '16 September, 2024 - 5:30 pm',
                    '3 rooms - 15 tasks',
                    '100.00',
                    'Marked as Completed',
                    Colors.grey),
              ],
            ),
            // Past tasks
            Center(
              child: Text('No past tasks available'),
            ),
          ],
        ),
      ),
    );
  }
}
