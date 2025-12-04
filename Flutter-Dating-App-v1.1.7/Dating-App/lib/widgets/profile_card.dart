import 'package:dating_app/constants/constants.dart';
import 'package:dating_app/datas/user.dart';
import 'package:dating_app/dialogs/report_dialog.dart';
import 'package:dating_app/models/user_model.dart';
import 'package:dating_app/plugins/swipe_stack/swipe_stack.dart';
import 'package:dating_app/widgets/custom_badge.dart';
import 'package:dating_app/widgets/default_card_border.dart';
import 'package:dating_app/widgets/show_like_or_dislike.dart';
import 'package:dating_app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/helpers/app_helper.dart';

class ProfileCard extends StatelessWidget {
  /// User object
  final User user;

  /// Screen to be checked
  final String? page;

  /// Swiper position
  final SwiperPosition? position;

  ProfileCard({super.key, this.page, this.position, required this.user});

  // Local variables
  final AppHelper _appHelper = AppHelper();

  @override
  Widget build(BuildContext context) {
    // Variables
    final bool requireVip = page == 'require_vip' && !UserModel().userIsVip;
    late ImageProvider userPhoto;
    // Check user vip status
    if (requireVip) {
      userPhoto = const AssetImage('assets/images/crow_badge.png');
    } else {
      userPhoto = NetworkImage(user.userProfilePhoto);
    }

    //
    // Get User Birthday
    final DateTime userBirthday = DateTime(UserModel().user.userBirthYear,
        UserModel().user.userBirthMonth, UserModel().user.userBirthDay);
    // Get User Current Age
    final int userAge = UserModel().calculateUserAge(userBirthday);

    // Build profile card
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(9.0),
      child: Stack(
        children: [
          /// User Card
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            margin: const EdgeInsets.all(0),
            shape: defaultCardBorder(),
            child: Container(
              decoration: BoxDecoration(
                /// User profile image
                image: DecorationImage(

                    /// Show VIP icon if user is not vip member
                    image: userPhoto,
                    fit: requireVip ? BoxFit.contain : BoxFit.cover),
              ),
              child: Container(
                /// BoxDecoration to make user info visible
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Colors.transparent
                      ]),
                ),

                /// User info container
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// User fullname
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${user.userFullname}, '
                              '${userAge.toString()}',
                              style: TextStyle(
                                  fontSize: page == 'discover' ? 20 : 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Verification badge
                          if (user.userVerificationStatus == 'verified')
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8.0),

                      // User location
                      Row(
                        children: [
                          // Icon
                          const SvgIcon("assets/icons/location_point_icon.svg",
                              color: Color(0xffFFFFFF), width: 24, height: 24),

                          const SizedBox(width: 5),

                          // Locality & Country
                          Expanded(
                            child: Text(
                              "${user.userLocality}, ${user.userCountry}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Shared kinks (if any)
                      if (user.userKinks != null && user.userKinks!.isNotEmpty)
                        _buildKinkTags(),

                      /// User education

                      // Note: Uncoment the code below if you want to show the education

                      // Row(
                      //   children: [
                      //     const SvgIcon("assets/icons/university_icon.svg",
                      //         color: Colors.white, width: 20, height: 20),
                      //     const SizedBox(width: 5),
                      //     Expanded(
                      //       child: Text(
                      //         user.userSchool,
                      //         style: const TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 16,
                      //         ),
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // const SizedBox(height: 3),

                      // User job title
                      // Note: Uncoment the code below if you want to show the job title

                      // Row(
                      //   children: [
                      //     const SvgIcon("assets/icons/job_bag_icon.svg",
                      //         color: Colors.white, width: 17, height: 17),
                      //     const SizedBox(width: 5),
                      //     Expanded(
                      //       child: Text(
                      //         user.userJobTitle,
                      //         style: const TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 16,
                      //         ),
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      page == 'discover'
                          ? const SizedBox(height: 70)
                          : const SizedBox(width: 0, height: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Show location distance
          Positioned(
            top: 10,
            left: page == 'discover' ? 8 : 5,
            child: CustomBadge(
                icon: page == 'discover'
                    ? const SvgIcon("assets/icons/location_point_icon.svg",
                        color: Colors.white, width: 15, height: 15)
                    : null,
                text:
                    '${_appHelper.getDistanceBetweenUsers(userLat: user.userGeoPoint.latitude, userLong: user.userGeoPoint.longitude)}km'),
          ),

          /// Show compatibility score on discover page
          if (page == 'discover' && user.userKinks != null && user.userKinks!.isNotEmpty)
            _buildCompatibilityBadge(context),

          /// Show Like or Dislike
          page == 'discover'
              ? ShowLikeOrDislike(position: position!)
              : const SizedBox(width: 0, height: 0),

          /// Show message icon
          page == 'matches'
              ? Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const SvgIcon("assets/icons/message_icon.svg",
                          color: Colors.white, width: 30, height: 30)),
                )
              : const SizedBox(width: 0, height: 0),

          // Show Report/Block profile button
          page == 'discover'
              ? Positioned(
                  right: 0,
                  child: IconButton(
                      icon: Icon(Icons.flag,
                          color: Theme.of(context).primaryColor, size: 32),
                      onPressed: () =>
                          ReportDialog(userId: user.userId).show()))
              : const SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }

  /// Build kink tags widget
  Widget _buildKinkTags() {
    final sharedKinks = UserModel().getSharedKinks(user.userKinks);
    final displayKinks = sharedKinks.isNotEmpty
        ? sharedKinks.take(3).toList()
        : (user.userKinks?.take(3).toList() ?? []);

    if (displayKinks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: displayKinks.map((kink) {
        final isShared = sharedKinks.contains(kink);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isShared ? Colors.pinkAccent : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isShared ? Colors.white : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isShared)
                const Icon(
                  Icons.favorite,
                  size: 12,
                  color: Colors.white,
                ),
              if (isShared) const SizedBox(width: 4),
              Text(
                kink.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isShared ? FontWeight.bold : FontWeight.normal,
                  color: isShared ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Build compatibility badge
  Widget _buildCompatibilityBadge(BuildContext context) {
    final compatibilityScore = UserModel().calculateCompatibilityScore(user.userKinks);

    if (compatibilityScore == 0) {
      return const SizedBox.shrink();
    }

    Color badgeColor;
    if (compatibilityScore >= 75) {
      badgeColor = Colors.green;
    } else if (compatibilityScore >= 50) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.red;
    }

    return Positioned(
      top: 10,
      right: 45,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '$compatibilityScore%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
