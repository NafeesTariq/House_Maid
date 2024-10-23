import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Task Details',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Price
              _buildSectionTitle('Task Price'),
              _buildPriceCard(),

              // Selected Services
              _buildSectionTitle('Selected Services'),
              _buildSelectedServices(['Deep Cleaning', 'Cooking']),

              // Date & Time
              _buildSectionTitle('Date & Time'),
              _buildInfoCard(
                  Icons.calendar_today, 'Monday, 9 Aug 2024\n10:00 AM'),

              // Home Address
              _buildSectionTitle('Home Address'),
              _buildInfoCard(Icons.location_on,
                  'House#, Street no. Street name, city, state, country.'),

              // Rooms
              _buildSectionTitle('Rooms'),
              _buildRoomList(),

              // Add-On Services
              _buildSectionTitle('Add-On Services'),
              _buildAddOnServices(['Cooking']),

              // Other Options
              _buildSectionTitle('Other Options'),
              _buildOtherOptions(),

              // Notes for Tasker
              _buildSectionTitle('Notes for Tasker'),
              _buildNotesField(),

              // Accept Task Button
              const SizedBox(height: 20),
              _buildAcceptButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        title: Text('Fixed Price'),
        trailing: Text(
          '100\$',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildSelectedServices(List<String> services) {
    return Wrap(
      spacing: 8.0,
      children: services
          .map((service) => Chip(
                label: Text(service),
                backgroundColor: Colors.pinkAccent.withOpacity(0.1),
                labelStyle: TextStyle(color: Colors.pinkAccent),
              ))
          .toList(),
    );
  }

  Widget _buildInfoCard(IconData icon, String content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.pinkAccent),
        title: Text(content),
      ),
    );
  }

  Widget _buildRoomList() {
    final rooms = [
      {
        'name': 'Bathroom',
        'tasks': '5 tasks',
        'image': 'assets/images/profile_image.png'
      },
      {
        'name': 'Dining Room',
        'tasks': '5 tasks',
        'image': 'assets/images/profile_image.png'
      },
      {
        'name': 'Kitchen',
        'tasks': '5 tasks',
        'image': 'assets/images/profile_image.png'
      },
    ];

    return Column(
      children: rooms
          .map((room) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                elevation: 2,
                child: ListTile(
                  leading: Image.asset(room['image']!,
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(room['name']!),
                  subtitle: Text(room['tasks']!),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildAddOnServices(List<String> services) {
    return Wrap(
      spacing: 8.0,
      children: services
          .map((service) => Chip(
                label: Text(service),
                backgroundColor: Colors.pinkAccent.withOpacity(0.1),
                labelStyle: TextStyle(color: Colors.pinkAccent),
              ))
          .toList(),
    );
  }

  Widget _buildOtherOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('House with pets'),
        Switch(
          value: true,
          onChanged: (bool value) {
            // Handle switch change
          },
          activeColor: Colors.pinkAccent,
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'If you have any further requests or have any instructions for tasker, please enter them here.',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          // Handle accept task action
        },
        child: Text(
          'Accept Task',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
