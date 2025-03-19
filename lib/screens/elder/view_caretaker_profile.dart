import 'package:elderly_care/provider/caretaker_profile_provider.dart';
import 'package:elderly_care/screens/caretaker/add_reminder.dart';
import 'package:elderly_care/utils/date_utils.dart';
import 'package:elderly_care/utils/in_app_notification.dart';
import 'package:elderly_care/utils/validators.dart';
import 'package:elderly_care/widgets/appbar.dart';
import 'package:elderly_care/widgets/buttons.dart';
import 'package:elderly_care/widgets/in_app_notification_widget.dart';
import 'package:elderly_care/widgets/no_data_found_widget.dart';
import 'package:elderly_care/widgets/star_rating.dart';
import 'package:elderly_care/widgets/textfield_v2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../models/my_review.dart';
import '../../models/my_user.dart';
import '../../my_theme.dart';
import '../../widgets/image_widget.dart';

class ViewCaretakerProfileScreen extends StatefulWidget {
  const ViewCaretakerProfileScreen({Key? key}) : super(key: key);

  @override
  State<ViewCaretakerProfileScreen> createState() => _ViewCaretakerProfileScreenState();
}

class _ViewCaretakerProfileScreenState extends State<ViewCaretakerProfileScreen> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Profile",
        centerTitle: true,
        leadingWidgetColor: Colors.white,
        textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        appBarColor: MyTheme.primaryColor,
        elevation: 0,
      ),
      body: SizedBox(
        child: Column(
          children: [
            Consumer<ProfileProvider>(builder: (context, provider, child) {
              return _ImageSection(imageUrl: provider.selectedUser?.imageUrl);
            }),
            Consumer<ProfileProvider>(builder: (context, provider, child) {
              return _NameAndRatings(
                name: provider.selectedUser?.name ?? "-",
                stars: provider.rating,
                numberOfReviews: provider.reviews.length,
              );
            }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  children: [
                    TabBar(
                        indicator: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            // Creates border
                            color: MyTheme.secondaryColor),
                        unselectedLabelStyle: const TextStyle(
                            fontSize: 14, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w500),
                        labelStyle: const TextStyle(fontSize: 14, color: MyTheme.white, fontWeight: FontWeight.w600),
                        unselectedLabelColor: MyTheme.secondaryAccentColor,
                        controller: _tabController,
                        padding: const EdgeInsets.only(top: 16, bottom: 20),
                        labelPadding: const EdgeInsets.only(top: 8, bottom: 8),
                        onTap: (int index) {},
                        tabs: const [Text("About"), Text("Reviews")]),
                    Expanded(
                      child: Consumer<ProfileProvider>(builder: (context, provider, child) {
                        return TabBarView(controller: _tabController, children: [
                          _UserInfo(user: provider.selectedUser),
                          _ReviewSection(
                            reviews: provider.reviews,
                            shouldShowReviewButton: provider.shouldShowReviewButton,
                          )
                        ]);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({Key? key, this.imageUrl}) : super(key: key);
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Container(
              height: 128,
              decoration: const BoxDecoration(
                  color: MyTheme.primaryColor, borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
            ),
            const SizedBox(
              height: 32,
            )
          ],
        ),
        Container(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white, width: 2)),
          child: ImageOrIconWidget(
            imageUrl: imageUrl ?? "https://picsum.photos/200",
            size: const Size(96, 96),
            borderRadius: 12,
          ),
        )
      ],
    );
  }
}

class _NameAndRatings extends StatelessWidget {
  const _NameAndRatings({Key? key, required this.name, required this.stars, required this.numberOfReviews})
      : super(key: key);

  final String name;
  final double stars;
  final int numberOfReviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: MyTheme.primaryColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StarRatingV2(
              initialRating: stars,
              ratingIconColor: MyTheme.accentColor,
            ),
            Text(
              "$stars/5.0 ($numberOfReviews)",
              style: GoogleFonts.inter(fontSize: 12, color: MyTheme.accentColor, fontWeight: FontWeight.w500),
            )
          ],
        )
      ],
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({Key? key, required this.user}) : super(key: key);
  final MyUser? user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const _IconAndValue(iconData: Icons.work_outline_rounded, value: "Work"),
          const _IconAndValue(iconData: Icons.hourglass_empty_rounded, value: "4+ yrs"),
          const _IconAndValue(iconData: Icons.location_pin, value: "Mumbai"),
          _IconAndValue(iconData: Icons.person, value: user?.gender ?? ""),
          _IconAndValue(iconData: Icons.calendar_month_rounded, value: "${user?.calculateAge} yrs old"),
          const _IconAndValue(iconData: Icons.language, value: "Hindi,English"),
          const Text(
            "About me",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MyTheme.primaryColor),
          ),
          const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vehicula viverra nulla, et finibus lorem volutpat et. Donec id blandit odio, eu ultrices erat. In vulputate odio sed ligula tempus, nec eleifend lacus tincidunt. Donec quis massa semper, pellentesque felis sed, tincidunt enim. Interdum et malesuada fames ac ante ipsum primis in faucibus. Suspendisse lacinia maximus tellus, nec congue sem mollis at. Nulla luctus eros id neque commodo, non fringilla quam laoreet. Ut eleifend leo at leo vestibulum, ac sollicitudin turpis accumsan. Nulla sodales dignissim condimentum. Cras eu egestas enim. Praesent mi libero, finibus id pharetra eu, tincidunt et metus. Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({Key? key, required this.reviews, required this.shouldShowReviewButton}) : super(key: key);

  final List<MyReview> reviews;
  final bool shouldShowReviewButton;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Column(
        children: [
          const NoDataFound(
            message: "No reviews found ",
          ),
          _addReviewButton(context)
        ],
      );
    }
    return Column(
      children: [
        const Text("Reviews"),
        Expanded(
          flex: 1,
          child: ListView.builder(
              itemCount: reviews.length, itemBuilder: (_, index) => _ReviewItem(review: reviews[index])),
        ),
        _addReviewButton(context)
      ],
    );
  }

  Widget _addReviewButton(BuildContext context) {
    return Visibility(
      visible: shouldShowReviewButton,
      child: PrimaryButton.expanded(
        onPressed: () {
          _showAddReviewBottomSheet(context);
        },
        text: "Add Review",
        margin: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  void _showAddReviewBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12.0),
          ),
        ),
        builder: (_) => Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(
                children: const [
                  SizedBox(height: 16),
                  BottomSheetIndicator(),
                  BottomSheetNameAndClose(title: "Add Review"),
                  _AddReview(),
                ],
              ),
            ));
  }
}

class _IconAndValue extends StatelessWidget {
  const _IconAndValue({Key? key, required this.iconData, required this.value}) : super(key: key);

  final IconData iconData;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: MyTheme.black_85,
          size: 16,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: MyTheme.black_85),
        )
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({Key? key, required this.review}) : super(key: key);

  final MyReview review;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ImageWidget(
          imageUrl: "https://picsum.photos/200",
          borderRadius: BorderRadius.circular(32),
          size: const Size(48, 48),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.senderName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MyTheme.primaryColor)),
                Text(MyDateUtils.parseTimeStamp(review.timeStamp),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: MyTheme.grey_102)),
                Text(review.description, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
        Row(
          children: const [
            Icon(
              Icons.star,
              color: MyTheme.golden,
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              "4.5",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MyTheme.golden),
            )
          ],
        )
      ],
    );
  }
}

class _AddReview extends StatefulWidget {
  const _AddReview({Key? key}) : super(key: key);

  @override
  State<_AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<_AddReview> {
  double _rating = 4;
  final _review = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          StarRatingV2(
            isReadOnly: false,
            initialRating: _rating,
            onRatingChanged: _onRatingChanged,
            ratingIconSize: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: MyTextFieldV2(
              maxLines: 3,
              labelText: "Review",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Review about caretaker",
              controller: _review,
              validator: (value) => MyValidator.defaultValidator(value),
            ),
          ),
          Consumer<ProfileProvider>(builder: (context, provider, child) {
            return PrimaryButton.expanded(
              enable: !provider.isLoading,
              onPressed: () async {
                if (_formKey.currentState?.validate() == true && !provider.isLoading) {
                  provider.addReview(_review.text, _rating).then((value) {
                    if (value.success) {
                      Navigator.pop(context);
                      InAppNotification.show(context,
                          title: "Success",
                          subtitle: "Added review successfully",
                          notificationType: NotificationType.success);
                    }
                  });
                }
              },
              text: "Submit",
              margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            );
          }),
        ],
      ),
    );
  }

  void _onRatingChanged(double rating) {
    _rating = rating;
    setState(() {});
  }
}

class ViewElderProfileScreen extends StatelessWidget {
  const ViewElderProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Profile",
        centerTitle: true,
        leadingWidgetColor: Colors.white,
        textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        appBarColor: MyTheme.primaryColor,
        elevation: 0,
      ),
      body: SizedBox(
        child: Column(
          children: [
            Consumer<ProfileProvider>(builder: (context, provider, child) {
              return _ImageSection(imageUrl: provider.selectedUser?.imageUrl);
            }),
            Consumer<ProfileProvider>(builder: (context, provider, child) {
              return Text(
                provider.selectedUser?.name ?? "-",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: MyTheme.primaryColor),
              );
            }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Consumer<ProfileProvider>(
                  builder: (context, provider, child) {
                    var user = provider.selectedUser;
                    var assignedCaretaker = provider.assignedCareTakers.firstOrNull;
                    return Column(
                      children: [
                        _IconAndValue(iconData: Icons.location_pin, value: user?.address ?? "-"),
                        _IconAndValue(iconData: Icons.person, value: user?.gender ?? ""),
                        _IconAndValue(iconData: Icons.calendar_month_rounded, value: "${user?.calculateAge} yrs old"),
                        Visibility(
                            visible: assignedCaretaker?.name?.isNotEmpty == true,
                            child: _IconAndValue(
                                iconData: Icons.medical_services, value: "CareTaker: ${assignedCaretaker?.name}")),
                        Visibility(
                            visible: user?.assignedOldAge?.isNotEmpty == true,
                            child: _IconAndValue(iconData: Icons.home, value: "${user?.assignedOldAge}")),

                        //todo: Create a list of assigned caretaker or tab view with assigned caretakers
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
