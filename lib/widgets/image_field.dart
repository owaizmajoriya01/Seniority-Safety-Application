import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../my_theme.dart';
import '../utils/number_utils.dart';


class _ExpenseFieldImage extends StatelessWidget {
  final String? imageUrl;
  final Color iconBgColor;
  final String? filePath;

  const _ExpenseFieldImage(
      {Key? key, this.imageUrl, this.iconBgColor = const Color.fromRGBO(242, 242, 242, 1), this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null && filePath == null) {
      return _defaultImageContainer();
    } else {
      if (filePath == null) {
        return _defaultImageContainer();
        /*return Image.network(
          imageUrl!,
          height: 60,
          width: 60,
          errorBuilder: (context, object, stackTrace) {
            return _defaultImageContainer();
          },
        );*/
      } else {
        return Image.file(
          File(filePath!),
          height: 60,
          width: 60,
          fit: BoxFit.fill,
          errorBuilder: (context, object, stackTrace) {
            return _defaultImageContainer();
          },
        );
      }
    }
  }

  Widget _defaultImageContainer() {
    return Container(
      width: 60,
      height: 60,
      color: iconBgColor,
      padding: const EdgeInsets.all(20),
      child: SvgPicture.asset(_getAssetName()),
    );
  }

  _getAssetName() {
    //return const Icon(Icons.person);
    return "assets/svg/selfie_2.svg";
    /*switch (imageType) {
      case IconType.Person:
        return 'assets/expense_svg/person_vector.svg';
      case IconType.Home:
        return 'assets/expense_svg/home_vector.svg';
      case IconType.Attachment:
      //return 'assets/expense_svg/attachment_vector.svg';
        return 'assets/attachment_vector.svg';
      case IconType.Approver:
        return 'assets/expense_svg/person_vector.svg';
        break;
    }*/
  }
}

class ExpenseImageField<T> extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? imageUrl;

  // final IconType iconType;
  final String? imagePath;
  final T? selectedValue;
  final bool dashedBorder;
  final EdgeInsets margin;
  final Color color;
  final Function()? onTap;
  final Function()? onRemovePressed;
  final String Function(String?)? validator;

  const ExpenseImageField(
      {Key? key,
      required this.title,
      this.subTitle,
      //required this.iconType,
      this.imagePath,
      this.selectedValue,
      this.dashedBorder = false,
      this.margin = const EdgeInsets.only(top: 20),
      this.color = MyTheme.primaryColor,
      this.onTap,
      this.validator,
      this.onRemovePressed,
      this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField(
        initialValue: selectedValue.toString(),
        validator: validator ??
            (String? value) {
              if (value != null && value.isNotEmpty) {
                return null;
              } else {
                return "Invalid Data";
              }
            },
        builder: (FormFieldState<dynamic> state) {
          return GestureDetector(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: state.hasError ? Colors.red : const Color.fromRGBO(204, 204, 204, 1), width: 1),
                  ),
                  margin: margin,
                  padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _ExpenseFieldImage(
                          imageUrl: imageUrl,
                          filePath: imagePath,
                          //iconType: iconType,
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400, fontSize: 14, color: Color.fromRGBO(85, 85, 85, 1)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: FutureBuilder<int>(
                                  future: _getFileSize(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        MyNumberUtils().formatBytes(snapshot.data, decimals: 2),
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Color.fromRGBO(85, 85, 85, 1)),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onRemovePressed,
                          splashRadius: 16,
                          color: Colors.red,
                          icon: const Icon(Icons.clear))
                    ],
                  ),
                ),
                if (state.hasError) _ErrorText(errorText: state.errorText),
              ],
            ),
          );
        });
  }

  Future<int> _getFileSize() async {
    debugPrint('Debug ExpenseImageField._getFileSize : $imageUrl ');
    if (imagePath != null) {
      return File(imagePath!).length();
    } else if (imageUrl != null) {
      Response r = await head(Uri.parse(imageUrl!));
      return int.tryParse(r.headers["content-length"] ?? "0") ?? 1;
    } else {
      return Future.value(2);
    }
  }
}

class _ErrorText extends StatelessWidget {
  final String? errorText;

  const _ErrorText({Key? key, this.errorText}) : super(key: key);

  get _errorTextStyle => GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8),
      child: Text(
        errorText ?? "Invalid Data",
        style: _errorTextStyle,
      ),
    );
  }
}
