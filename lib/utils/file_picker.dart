import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/ripple_effect_widget.dart';


class MyImagePicker {
  static showImagePickerDialog(
      BuildContext context, void Function(ImageSource imageSource, File? image) onImageSelected) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: _ImagePickerDialog(
                  onImageSelected: onImageSelected,
                ),
              ),
            ));
  }

  static Future<MyImagePickerResult> pickImage({
    required ImageSource source,
    int imageQuality=80,
  }) async {
    ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: source,imageQuality: imageQuality, preferredCameraDevice: CameraDevice.front);
      if (file != null) {
        return MyImagePickerResult(File(file.path), null, true);
      } else {
        return MyImagePickerResult(null, "Some Error Occurred", false);
      }
    } catch (e) {
      return MyImagePickerResult(null, e.toString(), false);
    }
  }
}

class MyImagePickerResult {
  final File? file;
  final String? errorMessage;
  final bool success;

  MyImagePickerResult(this.file, this.errorMessage, this.success);
}

class _ImagePickerDialog extends StatelessWidget {
  const _ImagePickerDialog({Key? key, required this.onImageSelected}) : super(key: key);

  final void Function(ImageSource imageSource, File? image) onImageSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Choose Image From",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black38)),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ImagePickerOption(
              title: 'Camera',
              iconData: Icons.camera_alt,
              onTap: () async {
                Navigator.pop(context);
                var result = await MyImagePicker.pickImage(source: ImageSource.camera);
                onImageSelected(ImageSource.camera, result.file);
              },
            ),
            _ImagePickerOption(
              title: 'Gallery',
              iconData: Icons.photo_rounded,
              onTap: () async {
                Navigator.pop(context);
                var result = await MyImagePicker.pickImage(source: ImageSource.gallery);
                onImageSelected(ImageSource.gallery, result.file);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ImagePickerOption extends StatelessWidget {
  const _ImagePickerOption({Key? key, required this.title, required this.onTap, required this.iconData})
      : super(key: key);

  final String title;
  final IconData iconData;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyRippleEffectWidget(
            onTap: onTap,
            /*decoration: BoxDecoration(
              border: Border.all(color: MyColors.tabBarColor, width: 2),
              borderRadius: BorderRadius.circular(16),
              color: MyColors.primaryColor.withOpacity(0.3),
            ),*/
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                iconData,
                color: Colors.black38,
                size: 64,
              ),
            )),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black38),
        ),
      ],
    );
  }
}
