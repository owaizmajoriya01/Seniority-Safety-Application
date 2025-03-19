import 'dart:io';

import 'package:flutter/material.dart';

import '../../my_theme.dart';
import '../../utils/file_picker.dart';
import '../../widgets/appbar.dart';
import '../../widgets/buttons.dart';
import '../../widgets/image_widget.dart';
import '../../widgets/ripple_effect_widget.dart';
import '../../widgets/textfield_v2.dart';

class CaretakerProfileV1 extends StatefulWidget {
  const CaretakerProfileV1({Key? key}) : super(key: key);

  @override
  State<CaretakerProfileV1> createState() => _CaretakerProfileV1State();
}

class _CaretakerProfileV1State extends State<CaretakerProfileV1> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProfileScreenV1 extends StatelessWidget {
  const ProfileScreenV1({Key? key}) : super(key: key);

  static const  _spaceBetweenTextfield = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.white,
      appBar: const MyAppBar(
        title: 'Edit Profile',
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                      const _ProfileImage(),
                      const SizedBox(height: _spaceBetweenTextfield),
                      const TitleWrapper(
                        title: ' First Name',
                        child: MyTextFieldV2(
                          prefix: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: _spaceBetweenTextfield),
                      const TitleWrapper(
                        title: 'Last Name',
                        child: MyTextFieldV2(
                          prefix: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: _spaceBetweenTextfield),
                      const TitleWrapper(title: 'Email', child: MyTextFieldV2(prefix: Icon(Icons.email))),
                      const SizedBox(height: _spaceBetweenTextfield),
                      const TitleWrapper(
                          title: 'Mobile Number', child: MyTextFieldV2(prefix: Icon(Icons.phone_android))),
                      const SizedBox(height: _spaceBetweenTextfield),
                      TitleWrapper(
                        title: 'Address',
                        child: MyTextFieldV2(
                          prefix: const Icon(Icons.location_city),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.length < 10) {
                              return "Test Error";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PrimaryButton.expanded(
              onPressed: () {},
              text: "SUBMIT",
              enableColor: MyTheme.secondaryColor,
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            )
          ],
        ),
      ),
    );
  }
}

class _ProfileImage extends StatefulWidget {
  const _ProfileImage({Key? key}) : super(key: key);

  @override
  State<_ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<_ProfileImage> {
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: MyTheme.secondaryColor), shape: BoxShape.circle),
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.only(bottom: 12),
          child: ImageWidget(
            imageUrl: "https://picsum.photos/100/100",
            file: profileImage,
            borderRadius: BorderRadius.circular(96),
            size: const Size(96, 96),
          ),
        ),
        Positioned.fill(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: MyRippleEffectWidget(
                borderRadius: 32,
                onTap: () async {
                  await MyImagePicker.showImagePickerDialog(context, (source, file) {
                    profileImage = file;
                    setState(() {});
                  });
                },
                decoration: const BoxDecoration(shape: BoxShape.circle, color: MyTheme.primaryColor),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )),
        )
      ],
    );
  }
}
