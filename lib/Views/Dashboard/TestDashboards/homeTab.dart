import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:house_maid_project/APIs/APIsClass.dart';
import 'package:house_maid_project/CustomWidgets/errorDialogue.dart';
import 'package:house_maid_project/Views/RegisterScreens/HouseMaidRegisteration/QuestionsScreens/HousemaidBefore.dart';
import 'package:house_maid_project/Views/login/loginScreen.dart';

class HouseMaidDashboardTab extends StatefulWidget {
  @override
  _HouseMaidDashboardTabState createState() => _HouseMaidDashboardTabState();
}

class _HouseMaidDashboardTabState extends State<HouseMaidDashboardTab> {
  final GetStorage _storage = GetStorage();
  APIs ApiService = APIs();
  String? _roleId;

  @override
  void initState() {
    super.initState();
    // Read roleId from local storage
    _roleId = _storage.read('roleId')?.toString();
  }

  @override
  Widget build(BuildContext context) {
    print('role status is : ${_storage.read('roleId')}');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 254, 176, 217),
                ),
                child: Center(
                  child: Text(
                    'House Maid Application',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: const Color.fromARGB(255, 254, 176, 217),
                ),
                title: Text('House Maid'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              if (_roleId == '1') ...[
                // Show "Register as a Housemaid" button if roleId is 1
                ListTile(
                  leading: Icon(
                    Icons.app_registration_outlined,
                    color: const Color.fromARGB(255, 254, 176, 217),
                  ),
                  title: Text('Register as a Housemaid'),
                  onTap: () {
                    Get.to(HouseMaidBefore());
                    // Add your registration logic here
                  },
                ),
              ] else if (_roleId == '12') ...[
                // Show "Switch Account" button with options if roleId is 12
                ListTile(
                  leading: Icon(
                    Icons.switch_account,
                    color: const Color.fromARGB(255, 254, 176, 217),
                  ),
                  title: Text('Switch Account'),
                  onTap: () {
                    _showSwitchAccountOptions(context);
                  },
                ),
              ],
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: const Color.fromARGB(255, 254, 176, 217),
                ),
                title: Text('Logout'),
                onTap: () async {
                  // Close the drawer
                  Navigator.pop(context);

                  // Show a loading indicator while the logout request is being processed
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // Call the LogoutAPI function
                  var response = await ApiService.LogoutAPI();

                  // Close the loading indicator
                  Navigator.of(context).pop();

                  // Check if logout was successful
                  if (response.message == "Logged out successfully") {
                    // Clear local storage
                    final storage = GetStorage();
                    await storage.erase(); // Clear all stored data

                    // Navigate to the login screen or a splash screen
                    Get.offAll(() => LoginScreen());
                  } else {
                    // Show an error message if logout failed
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(response.message ??
                    //         "Failed to log out. Please try again."),
                    //   ),
                    // );

                    ErrorDialog.showError(context, '${response.message}');
                  }
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // Top section with Drawer Icon, Avatar, and Badge (Fixed)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top Row with Drawer Icon and Avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Drawer Icon Button
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                      // Circular Avatar on the Right
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage('assets/images/profileimage.jpg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Badge Section (Fixed)
                  _buildIconAndLevel(),
                ],
              ),
            ),

            // Scrollable Content Below the Fixed Header
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      _buildStatsContainer(),
                      const SizedBox(height: 16),
                      _buildEarningsContainer(),
                      const SizedBox(height: 16),
                      _buildAdditionalInfoContainer(),
                      const SizedBox(height: 16),
                      _buildNewSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show switch account options
  void _showSwitchAccountOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Switch to Client Account'),
              onTap: () {
                Navigator.pop(context);
                // Add your logic to switch to client account here
              },
            ),
            ListTile(
              leading: Icon(Icons.home_repair_service),
              title: Text('Switch to Housemaid Account'),
              onTap: () {
                Navigator.pop(context);
                // Add your logic to switch to housemaid account here
              },
            ),
          ],
        );
      },
    );
  }

  // Badge Section
  Widget _buildIconAndLevel() {
    return Column(
      children: [
        Image.asset(
          'assets/images/badge.png', // Replace with your badge image path
          height: 100,
          width: 100,
        ),
        const SizedBox(height: 8),
        const Text(
          'Level 5',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Stats Container
  Widget _buildStatsContainer() {
    return _buildSectionContainer(
      children: [
        _buildBoldInfoRow('Orders', 40, 20),
        _buildBoldInfoRow('Unique Clients', 15, 20),
        _buildBoldInfoRow('Earnings', 2200.00, 3000.00, isCurrency: true),
        _buildInfoRow('Avg. Response Rate', 'Minimum 1 hour', highlight: true),
        _buildInfoRow('Ratings', '4.7/4.5'),
      ],
    );
  }

  // Earnings Container
  Widget _buildEarningsContainer() {
    return _buildSectionContainer(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Earnings (Last 30 days)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Details',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFFEB0D9),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Additional Info Container
  Widget _buildAdditionalInfoContainer() {
    return _buildSectionContainer(
      children: [
        _buildInfoRow('Earning in August', '\$200'),
        _buildInfoRow('Avg. Selling Price', '\$100'),
        _buildInfoRow('Active tasks', '2 (\$200)'),
        _buildInfoRow('Available for withdrawal', '\$200'),
      ],
    );
  }

  // New Section Below Additional Info
  Widget _buildNewSection() {
    return _buildSectionContainer(
      children: [
        _buildInfoRow('Completed Orders', '100'),
        _buildInfoRow('Pending Orders', '5'),
        _buildInfoRow('Total Earnings', '\$10,000'),
      ],
    );
  }

  // Helper: Section Container with Shadow
  Widget _buildSectionContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // Helper: Row with Bold Stats
  Widget _buildBoldInfoRow(String title, num currentValue, num totalValue,
      {bool isCurrency = false}) {
    String formattedCurrent = isCurrency
        ? '\$${currentValue.toStringAsFixed(2)}'
        : currentValue.toString();
    String formattedTotal = isCurrency
        ? '\$${totalValue.toStringAsFixed(2)}'
        : totalValue.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: formattedCurrent,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: '/$formattedTotal',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Info Row
  Widget _buildInfoRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? Color(0xFFFEB0D9) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';

// class HouseMaidDashboardTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: NestedScrollView(
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return [
//               SliverAppBar(
//                 backgroundColor: Colors.white,
//                 elevation: 0,
//                 pinned: true, // Keep the top section fixed
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Top Row with Logo and Avatar
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Logo/Icon on the Left
//                             Image.asset(
//                               'assets/images/logo.png', // Replace with actual logo path
//                               height: 40,
//                             ),
//                             // Circular Avatar on the Right
//                             CircleAvatar(
//                               radius: 20,
//                               backgroundImage: NetworkImage(
//                                 'https://via.placeholder.com/150', // Replace with actual image URL
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 25), // Spacing before badge

//                         // Badge and Level Section
//                         _buildIconAndLevel(),
//                       ],
//                     ),
//                   ),
//                 ),
//                 expandedHeight: 300, // Adjust height as needed
//               ),
//             ];
//           },
//           // Scrollable content starts here
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 16),
//                   _buildStatsContainer(),
//                   const SizedBox(height: 16),
//                   _buildEarningsContainer(),
//                   const SizedBox(height: 16),
//                   _buildAdditionalInfoContainer(),
//                   const SizedBox(height: 16),
//                   _buildNewSection(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Badge and Level Section
//   Widget _buildIconAndLevel() {
//     return Column(
//       children: [
//         Image.asset(
//           'assets/images/badge.png', // Replace with actual badge path
//           height: 100,
//           width: 100,
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'Level 5',
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }

//   // Stats Container
//   Widget _buildStatsContainer() {
//     return _buildSectionContainer(
//       children: [
//         _buildBoldInfoRow('Orders', 40, 20),
//         _buildBoldInfoRow('Unique Clients', 15, 20),
//         _buildBoldInfoRow('Earnings', 2200.00, 3000.00, isCurrency: true),
//         _buildInfoRow('Avg. Response Rate', 'Minimum 1 hour', highlight: true),
//         _buildInfoRow('Ratings', '4.7/4.5'),
//       ],
//     );
//   }

//   Widget _buildEarningsContainer() {
//     return _buildSectionContainer(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             Text(
//               'Earnings (Last 30 days)',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               'Details',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Color(0xFFFEB0D9),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAdditionalInfoContainer() {
//     return _buildSectionContainer(
//       children: [
//         _buildInfoRow('Earning in August', '\$200'),
//         _buildInfoRow('Avg. Selling Price', '\$100'),
//         _buildInfoRow('Active tasks', '2 (\$200)'),
//         _buildInfoRow('Available for withdrawal', '\$200'),
//       ],
//     );
//   }

//   Widget _buildNewSection() {
//     return _buildSectionContainer(
//       children: [
//         _buildInfoRow('Completed Orders', '100'),
//         _buildInfoRow('Pending Orders', '5'),
//         _buildInfoRow('Total Earnings', '\$10,000'),
//       ],
//     );
//   }

//   // Helper: Section Container with Padding and Shadow
//   Widget _buildSectionContainer({required List<Widget> children}) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 8,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(children: children),
//     );
//   }

//   // Helper: Bold Info Row
//   Widget _buildBoldInfoRow(String title, num currentValue, num totalValue,
//       {bool isCurrency = false}) {
//     String formattedCurrent = isCurrency
//         ? '\$${currentValue.toStringAsFixed(2)}'
//         : currentValue.toString();
//     String formattedTotal = isCurrency
//         ? '\$${totalValue.toStringAsFixed(2)}'
//         : totalValue.toString();

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 16, color: Colors.black87),
//           ),
//           RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: formattedCurrent,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 TextSpan(
//                   text: '/$formattedTotal',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.normal,
//                     fontSize: 16,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper: Info Row
//   Widget _buildInfoRow(String title, String value, {bool highlight = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 16, color: Colors.black87),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
//               color: highlight ? Color(0xFFFEB0D9) : Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
