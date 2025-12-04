import 'dart:io';
import 'package:dating_app/constants/constants.dart';
import 'package:dating_app/dialogs/common_dialogs.dart';
import 'package:dating_app/dialogs/progress_dialog.dart';
import 'package:dating_app/helpers/app_localizations.dart';
import 'package:dating_app/models/user_model.dart';
import 'package:dating_app/widgets/image_source_sheet.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  File? _verificationPhoto;
  late AppLocalizations _i18n;
  late ProgressDialog _pr;

  /// Get verification photo from camera
  void _getVerificationPhoto() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ImageSourceSheet(
        onImageSelected: (image) {
          if (image != null) {
            setState(() {
              _verificationPhoto = image;
            });
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  /// Submit verification photo
  Future<void> _submitVerification() async {
    if (_verificationPhoto == null) {
      showScaffoldMessage(
        message: 'Please take a verification photo first',
      );
      return;
    }

    _pr.show(_i18n.translate("processing"));

    try {
      // Upload verification photo
      final String photoUrl = await UserModel().uploadFile(
        file: _verificationPhoto!,
        path: 'uploads/verification',
        userId: UserModel().user.userId,
      );

      // Update user verification status
      await UserModel().updateUserData(
        userId: UserModel().user.userId,
        data: {
          USER_VERIFICATION_PHOTO: photoUrl,
          USER_VERIFICATION_STATUS: 'pending',
        },
      );

      _pr.hide();

      // Show success dialog
      if (mounted) {
        successDialog(
          context,
          message: 'Verification photo submitted successfully! '
              'We\'ll review it within 24-48 hours.',
          positiveAction: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      _pr.hide();
      if (mounted) {
        errorDialog(
          context,
          message: 'Failed to submit verification: $e',
        );
      }
    }
  }

  void showScaffoldMessage({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _i18n = AppLocalizations.of(context);
    _pr = ProgressDialog(context, isDismissible: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Verified'),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, userModel) {
          final verificationStatus = userModel.user.userVerificationStatus ?? 'unverified';

          // Show status if already submitted
          if (verificationStatus == 'pending') {
            return _buildPendingStatus();
          }

          if (verificationStatus == 'verified') {
            return _buildVerifiedStatus();
          }

          if (verificationStatus == 'rejected') {
            return _buildRejectedStatus();
          }

          // Show verification form
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Verification badge icon
                Icon(
                  Icons.verified_user,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Get Your Green Badge!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Description
                const Text(
                  'Verified profiles get more matches and build trust in the community.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Instructions card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            const Text(
                              'Verification Requirements',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        _buildRequirementItem(
                          '1',
                          'Take a clear selfie in good lighting',
                        ),
                        _buildRequirementItem(
                          '2',
                          'Make a peace sign (✌️) with your hand visible',
                        ),
                        _buildRequirementItem(
                          '3',
                          'Make sure your face is clearly visible',
                        ),
                        _buildRequirementItem(
                          '4',
                          'Match the pose shown in your profile photos',
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber, color: Colors.orange),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'No filters, masks, or accessories that obscure your face',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Photo preview
                if (_verificationPhoto != null)
                  Column(
                    children: [
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            _verificationPhoto!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                // Take photo button
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _getVerificationPhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(
                      _verificationPhoto == null
                          ? 'Take Verification Photo'
                          : 'Retake Photo',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Submit button
                if (_verificationPhoto != null)
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Submit for Verification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Privacy note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your verification photo is only used for identity verification and won\'t be shown on your profile.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequirementItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingStatus() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pending_outlined,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            const Text(
              'Verification Pending',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your verification photo is under review. We\'ll notify you once it\'s approved!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'This usually takes 24-48 hours.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedStatus() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'You\'re Verified!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Congratulations! Your profile now has the green verification badge.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectedStatus() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cancel_outlined,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            const Text(
              'Verification Declined',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your verification photo didn\'t meet our requirements. Please try again with a clearer photo.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Reset status to allow resubmission
                  await UserModel().updateUserData(
                    userId: UserModel().user.userId,
                    data: {USER_VERIFICATION_STATUS: 'unverified'},
                  );
                  setState(() {});
                },
                child: const Text('Try Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
