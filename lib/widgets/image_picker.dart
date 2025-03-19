import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '/my_theme.dart';
import '../utils/file_picker.dart';
import 'image_widget.dart';
import 'ripple_effect_widget.dart';

///[ImagePickerWithLabel] uses this class internally.
class _ImagePickerWithLabel extends StatelessWidget {
  const _ImagePickerWithLabel(
      {Key? key,
      this.imagePath,
      required this.labelText,
      this.onImageSelected,
      this.isRequired = false,
      required this.borderColor,
      this.labelPadding})
      : super(key: key);

  final String? imagePath;
  final String labelText;

  ///callback function when image is selected
  final void Function(String path)? onImageSelected;

  ///padding for label
  final EdgeInsets? labelPadding;

  ///toggle visibility of red asterisk (*).
  ///
  /// if[isRequired] is true, red asterisk (*) is shown beside [labelText].
  final bool isRequired;

  final Color borderColor;

  //returns red asterisk if [isRequired] is true
  ///
  /// else return null
  List<TextSpan>? _buildAsterisk() {
    if (isRequired) {
      return [
        const TextSpan(text: " *", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red))
      ];
    } else {
      return null;
    }
  }

  EdgeInsets get _labelPadding => labelPadding ?? const EdgeInsets.only(bottom: 6.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openCamera,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: _labelPadding,
            child: RichText(
                text: TextSpan(
                    text: labelText,
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: MyTheme.primaryColor),
                    children: _buildAsterisk())),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 128,
              width: 196,
              child: Stack(
                children: [
                  Container(
                    height: 128,
                    width: 196,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: ImageWidget(
                      imagePath: imagePath,
                      size: const Size(96, 96),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: MyRippleEffectWidget(
                        decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(8)),
                        onTap: _openCamera,
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.camera_alt),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _openCamera() async {
    var image = await MyImagePicker.pickImage(source: ImageSource.camera);
    if (image.success && image.file != null) {
      onImageSelected?.call(image.file!.path);
    }
  }
}

///for info about parameters refer to [_ImagePickerWithLabel]
class ImagePickerWithLabel extends FormField<String> {
  ImagePickerWithLabel(
      {Key? key,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      AutovalidateMode autovalidate = AutovalidateMode.onUserInteraction,
      String? initialImagePath,
      required String labelText,
      Function(String? imagePth)? onImageSelected,
      EdgeInsets? labelPadding,
      required bool isRequired})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialImagePath,
            autovalidateMode: autovalidate,
            builder: (FormFieldState<String> state) {
              return Column(
                children: [
                  _ImagePickerWithLabel(
                    imagePath: initialImagePath,
                    labelText: labelText,
                    onImageSelected: (String? value) {
                      initialImagePath = value;
                      state.didChange(value);
                      onImageSelected?.call(value);
                    },
                    borderColor: state.hasError ? Colors.red : MyTheme.primaryColor,
                    isRequired: isRequired,
                    labelPadding: labelPadding,
                  ),
                  state.hasError
                      ? Text(
                          state.errorText ?? "Invalid Value",
                          style: const TextStyle(color: Colors.red),
                        )
                      : Container()
                ],
              );
            });
}

class ProfileImageWithPicker extends StatelessWidget {
  const ProfileImageWithPicker({Key? key, this.imagePath, this.imageUrl, this.onImageSelected, this.name})
      : super(key: key);

  final String? imagePath;
  final String? imageUrl;
  final String? name;
  final void Function(String path)? onImageSelected;

  static final _borderRadius = BorderRadius.circular(96);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144,
      width: 144,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
              height: 128,
              width: 128,
              decoration: BoxDecoration(
                borderRadius: _borderRadius,
                border: Border.all(color: MyTheme.secondaryAccentColor, width: 2),
              ),
              child: _buildImage()),
          Align(
            alignment: Alignment.bottomRight,
            child: MyRippleEffectWidget(
                decoration: BoxDecoration(color: MyTheme.accentColor, borderRadius: BorderRadius.circular(8)),
                onTap: () => _showImagePickerOptions(context),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(Icons.camera_alt),
                )),
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath == null ) {
      return ProfileImage(
        url: imageUrl,
        name: name ?? "Elderly Care",
      );
    } else {
      return ImageWidget(
        imagePath: imagePath,
        imageUrl: imageUrl,
        size: const Size(96, 96),
        borderRadius: _borderRadius,
      );
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Choose From:",style: GoogleFonts.poppins(fontSize: 16,color: MyTheme.secondaryAccentColor,fontWeight: FontWeight.w600),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,8,0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PickerOption(
                            source: ImageSource.camera,
                            onTap: (source) => popAndNavigate(source, _),
                          ),
                          const SizedBox(width: 32,),
                          _PickerOption(
                            source: ImageSource.gallery,
                            onTap: (source) => popAndNavigate(source, _),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<void> _openCamera() async {
    var image = await MyImagePicker.pickImage(source: ImageSource.camera);
    if (image.success && image.file != null) {
      onImageSelected?.call(image.file!.path);
    }
  }

  Future<void> _openGallery() async {
    var image = await MyImagePicker.pickImage(source: ImageSource.gallery);
    if (image.success && image.file != null) {
      onImageSelected?.call(image.file!.path);
    }
  }

  popAndNavigate(ImageSource source, BuildContext context) {
    Navigator.pop(context);
    switch (source) {
      case ImageSource.camera:
        _openCamera();
        break;
      case ImageSource.gallery:
        _openGallery();
        break;
    }
  }
}

class _PickerOption extends StatelessWidget {
  const _PickerOption({Key? key, required this.onTap, required this.source}) : super(key: key);

  final Function(ImageSource) onTap;
  final ImageSource source;

  @override
  Widget build(BuildContext context) {
    return MyRippleEffectWidget(
      onTap: () => onTap(source),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Icon(_icon,size: 40,), Text(_name,style : GoogleFonts.inter(fontSize: 12,color: MyTheme.secondaryAccentColor,fontWeight: FontWeight.w500))],
      ),
    );
  }

  String get _name {
    switch (source) {
      case ImageSource.camera:
        return "Camera";
      case ImageSource.gallery:
        return "Gallery";
    }
  }

  IconData get _icon {
    switch (source) {
      case ImageSource.camera:
        return Icons.camera_enhance_rounded;
      case ImageSource.gallery:
        return Icons.image_rounded;
    }
  }
}
