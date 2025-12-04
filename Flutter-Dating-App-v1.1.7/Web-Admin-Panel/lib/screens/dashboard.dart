import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_dashboard/constants/constants.dart';
import 'package:dating_app_dashboard/models/app_model.dart';
import 'package:dating_app_dashboard/widgets/my_navigation_drawer.dart';
import 'package:dating_app_dashboard/widgets/processing.dart';
import 'package:dating_app_dashboard/widgets/users_pie_chart.dart';
import 'package:dating_app_dashboard/widgets/statistic_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Variables
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _appInfo;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _users;

  /// Get AppInfo Stream to update UI after changes
  void _getAppInfoUpdates() {
    _appInfo = AppModel().getAppInfoStream();
    // Listen updates
    _appInfo.listen((appEvent) {
      // Update AppInfo object
      AppModel().updateAppObject(appEvent.data()!);
    });
  }

  /// Get Users Stream to listen updates
  void _getUsersUpdates() {
    _users = AppModel().getUsers();
    // Listen updates
    _users!.listen((usersEvent) {
      // Update users
      AppModel().updateUsers(usersEvent.docs);
      //AppModel().creteFakeUsers(usersEvent.docs[0].data());r
    });
  }

  /// Count User Statistics
  int _countUsers(
      List<DocumentSnapshot<Map<String, dynamic>>> users, String userStatus) {
    // Variables
    String field = USER_STATUS;
    dynamic status = userStatus;
    // Check status
    if (userStatus == 'verified') {
      field = USER_IS_VERIFIED;
      status = true;
    }
    return users.where((user) => user.data()![field] == status).toList().length;
  }

  /// Count verification requests
  int _countPendingVerifications(
      List<DocumentSnapshot<Map<String, dynamic>>> users) {
    return users
        .where((user) =>
            user.data()![USER_VERIFICATION_STATUS] == 'pending')
        .toList()
        .length;
  }

  /// Count age verified users
  int _countAgeVerified(List<DocumentSnapshot<Map<String, dynamic>>> users) {
    return users
        .where((user) => user.data()![USER_AGE_VERIFIED] == true)
        .toList()
        .length;
  }

  /// Get most popular kinks
  Map<String, int> _getPopularKinks(
      List<DocumentSnapshot<Map<String, dynamic>>> users) {
    final Map<String, int> kinkCounts = {};

    for (var user in users) {
      final List<dynamic>? userKinks = user.data()![USER_KINKS];
      if (userKinks != null) {
        for (var kink in userKinks) {
          kinkCounts[kink.toString()] =
              (kinkCounts[kink.toString()] ?? 0) + 1;
        }
      }
    }

    // Sort by count and return top 10
    final sortedEntries = kinkCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries.take(10));
  }

  @override
  void initState() {
    super.initState();
    // Get updates
    _getUsersUpdates();
    _getAppInfoUpdates();
  }

  @override
  void dispose() {
    _appInfo.drain();
    _users?.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(APP_NAME)),
        drawer: const MyNavigationDrawer(),
        backgroundColor: Colors.grey.withAlpha(70),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _users,
            builder: (context, snapshot) {
              // Check data
              if (!snapshot.hasData) {
                return const Processing();
              } else {
                // Variables
                final List<DocumentSnapshot<Map<String, dynamic>>> users =
                    snapshot.data!.docs;
                // G
                final int totalActiveUsers = _countUsers(users, 'active');
                final int totalVerifiedUsers = _countUsers(users, 'verified');
                final int totalFlaggedUsers = _countUsers(users, 'flagged');
                final int totalBlockedUsers = _countUsers(users, 'blocked');
                final int pendingVerifications = _countPendingVerifications(users);
                final int ageVerifiedUsers = _countAgeVerified(users);
                final Map<String, int> popularKinks = _getPopularKinks(users);

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Dashboard Header
                      Center(
                        child: Container(
                          width: double.maxFinite,
                          color: Colors.white,
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: const [
                               Icon(Icons.score, size: 80, color: Colors.grey),
                               Text("Control Panel",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                               Text("Watch your bussiness growing in real time!",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),

                      // Dashboard Statistics section 01
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Total Users
                            StatisticCard(
                              iconBgColor: Colors.green,
                              icon: Icons.person_add_outlined,
                              total: totalActiveUsers,
                              description: "Total Active Users",
                            ),

                            // Total Verified Users
                            StatisticCard(
                              iconBgColor: Colors.blue,
                              icon: Icons.check,
                              total: totalVerifiedUsers,
                              description: "Total Verified Users",
                            ),

                            // Total Flagged Users
                            StatisticCard(
                              iconBgColor: Colors.amber,
                              icon: Icons.flag_outlined,
                              total: totalFlaggedUsers,
                              description: "Total Flagged Users",
                            ),

                            // Total Blocked Users
                            StatisticCard(
                              iconBgColor: Colors.red,
                              icon: Icons.lock_outlined,
                              total: totalBlockedUsers,
                              description: "Total Blocked Users",
                            ),

                            // Pending Verifications
                            StatisticCard(
                              iconBgColor: Colors.orange,
                              icon: Icons.verified_user_outlined,
                              total: pendingVerifications,
                              description: "Pending Verifications",
                            ),

                            // Age Verified Users
                            StatisticCard(
                              iconBgColor: Colors.teal,
                              icon: Icons.verified,
                              total: ageVerifiedUsers,
                              description: "Age Verified (18+)",
                            ),
                          ],
                        ),
                      ),

                      /// Show Pie Chart Statistic
                      UsersPieChart(
                        totalUsers: users.length,
                        totalActiveUsers: totalActiveUsers,
                        totalVerifiedUsers: totalVerifiedUsers,
                        totalFlaggedUsers: totalFlaggedUsers,
                        totalBlockedUsers: totalBlockedUsers,
                      ),

                      // Popular Kinks Section
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Top 10 Most Popular Kinks",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                            ...popularKinks.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        entry.key,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${entry.value} users',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
