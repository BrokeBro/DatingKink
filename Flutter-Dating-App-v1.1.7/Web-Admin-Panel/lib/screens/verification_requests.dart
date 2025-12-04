import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_dashboard/constants/constants.dart';
import 'package:dating_app_dashboard/models/app_model.dart';
import 'package:dating_app_dashboard/widgets/my_navigation_drawer.dart';
import 'package:dating_app_dashboard/widgets/processing.dart';
import 'package:flutter/material.dart';

class VerificationRequests extends StatefulWidget {
  const VerificationRequests({Key? key}) : super(key: key);

  @override
  _VerificationRequestsState createState() => _VerificationRequestsState();
}

class _VerificationRequestsState extends State<VerificationRequests> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _pendingVerifications;

  @override
  void initState() {
    super.initState();
    _getPendingVerifications();
  }

  void _getPendingVerifications() {
    _pendingVerifications = FirebaseFirestore.instance
        .collection(C_USERS)
        .where(USER_VERIFICATION_STATUS, isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> _approveVerification(String userId) async {
    try {
      await FirebaseFirestore.instance.collection(C_USERS).doc(userId).update({
        USER_VERIFICATION_STATUS: 'verified',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectVerification(String userId) async {
    try {
      await FirebaseFirestore.instance.collection(C_USERS).doc(userId).update({
        USER_VERIFICATION_STATUS: 'rejected',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification rejected'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification Requests')),
      drawer: const MyNavigationDrawer(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _pendingVerifications,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Processing();
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No pending verification requests',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 0.75,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final user = requests[index].data();
              final userId = user[USER_ID];
              final userName = user[USER_FULLNAME];
              final userAge = AppModel().calculateUserAge(DateTime(
                user[USER_BIRTH_YEAR],
                user[USER_BIRTH_MONTH],
                user[USER_BIRTH_DAY],
              ));
              final verificationPhoto = user[USER_VERIFICATION_PHOTO];
              final profilePhoto = user[USER_PROFILE_PHOTO];

              return Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.orange.withOpacity(0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Age: $userAge',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PENDING REVIEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Photos comparison
                    Expanded(
                      child: Row(
                        children: [
                          // Profile photo
                          Expanded(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Profile Photo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: profilePhoto != null
                                      ? Image.network(
                                          profilePhoto,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.person, size: 60),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 2,
                            color: Colors.grey[300],
                          ),
                          // Verification photo
                          Expanded(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Verification Photo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: verificationPhoto != null
                                      ? Image.network(
                                          verificationPhoto,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.photo, size: 60),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _rejectVerification(userId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.close),
                              label: const Text('Reject'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _approveVerification(userId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.check),
                              label: const Text('Approve'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
