import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '/my_theme.dart';

class MyTextFieldV2 extends StatelessWidget {
  const MyTextFieldV2({
    Key? key,
    this.autoValidateMode,
    this.inputFormatters,
    this.controller,
    this.onChanged,
    this.validator,
    this.hintText,
    this.labelText,
    this.borderRadius = 4,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    this.suffix,
    this.prefix,
    this.fillColor = Colors.white,
    this.onSubmit,
    this.isReadOnly = false,
    this.keyboardType,
    this.floatingLabelBehavior,
    this.maxLines,
    this.onSaved,
    this.borderColor = Colors.grey,
    this.onTap,
    this.minLines,
  }) : super(key: key);

  final AutovalidateMode? autoValidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmit;
  final void Function(String? value)? onSaved;
  final VoidCallback? onTap;
  final String? Function(String? value)? validator;
  final double borderRadius;
  final String? hintText;
  final String? labelText;
  final EdgeInsets? contentPadding;
  final Widget? suffix;
  final Widget? prefix;
  final Color? fillColor;
  final Color borderColor;

  ///if [isReadOnly] is true then this field is disabled and user cant interact with it.
  final bool isReadOnly;

  final TextInputType? keyboardType;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final int? maxLines;
  final int? minLines;

  static const borderWidth = 0.5;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      minLines: minLines,
      enabled: !isReadOnly,
      autovalidateMode: autoValidateMode,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      controller: controller,
      onChanged: onChanged,
      onSaved: onSaved,
      onTap: onTap,
      validator: validator,
      onFieldSubmitted: onSubmit,
      style: GoogleFonts.inter(color: MyTheme.black_85, fontWeight: FontWeight.w500, fontSize: 16),
      decoration: InputDecoration(
        floatingLabelBehavior: floatingLabelBehavior,
        fillColor: fillColor,
        filled: true,
        isDense: true,
        hintText: hintText,
        labelText: labelText,
        contentPadding: contentPadding,
        prefixIcon: prefix,
        suffixIcon: suffix,
        labelStyle: GoogleFonts.inter(color: MyTheme.primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyTheme.primaryColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyTheme.primaryColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    this.autoValidateMode,
    this.inputFormatters,
    this.controller,
    this.onChanged,
    this.validator,
    this.hintText,
    this.labelText,
    this.borderRadius = 4,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    this.fillColor = Colors.white,
    this.onSubmit,
    this.isReadOnly = false,
    this.keyboardType,
    this.floatingLabelBehavior,
    this.maxLines,
    this.onSaved,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  final AutovalidateMode? autoValidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmit;
  final void Function(String? value)? onSaved;
  final String? Function(String? value)? validator;
  final double borderRadius;
  final String? hintText;
  final String? labelText;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final Color borderColor;

  ///if [isReadOnly] is true then this field is disabled and user cant interact with it.
  final bool isReadOnly;

  final TextInputType? keyboardType;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final int? maxLines;

  static const borderWidth = 0.5;

  @override
  Widget build(BuildContext context) {
    return MyTextFieldV2(
      autoValidateMode: autoValidateMode,
      inputFormatters: inputFormatters,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      hintText: hintText,
      labelText: labelText,
      borderRadius: borderRadius,
      contentPadding: contentPadding,
      fillColor: fillColor,
      onSubmit: onSubmit,
      isReadOnly: isReadOnly,
      keyboardType: keyboardType,
      floatingLabelBehavior: floatingLabelBehavior,
      maxLines: maxLines,
      onSaved: onSaved,
      borderColor: borderColor,
      suffix: const Icon(Icons.search),
    );
  }
}

class MyTitleTextfieldV2 extends FormField<String> {
  MyTitleTextfieldV2(
      {super.key,
      super.onSaved,
      super.validator,
      super.initialValue,
      super.autovalidateMode = AutovalidateMode.onUserInteraction,
      TextEditingController? controller,
      String? hintText,
      required String labelText,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType,
      double borderRadius = 6,
      EdgeInsets contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      Widget? suffix,
      Widget? prefix,
      Color fillColor = Colors.white,
      bool isReadOnly = false,
      int? maxLines,
      Color borderColor = Colors.grey,
      double elevation = 2,
      double? borderWidth = 0.5,
      bool obscureText = false})
      : super(builder: (FormFieldState<String> state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitle(state.hasError, labelText),
              Material(
                elevation: elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: _Textfield(
                  hasError: state.hasError,
                  controller: controller,
                  hintText: hintText,
                  inputFormatters: inputFormatters,
                  keyboardType: keyboardType,
                  onChanged: (value) {
                    state.didChange(value);
                  },
                  borderRadius: borderRadius,
                  contentPadding: contentPadding,
                  suffix: suffix,
                  prefix: prefix,
                  fillColor: fillColor,
                  isReadOnly: isReadOnly,
                  borderWidth: borderWidth,
                  maxLines: maxLines,
                  borderColor: borderColor,
                  obscureText: obscureText,
                ),
              ),
              if (state.hasError) _buildErrorMessage(state.errorText),
            ],
          );
        });

  static const _errorColor = Colors.red;

  static Widget _buildTitle(bool hasError, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 2),
      child: Text(
        labelText,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: hasError ? _errorColor : MyTheme.secondaryAccentColor),
      ),
    );
  }

  static Widget _buildErrorMessage(String? errorMessage) {
    return Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline,
              color: _errorColor,
              size: 14,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                errorMessage ?? "-",
                maxLines: 9,
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: _errorColor),
              ),
            ),
          ],
        ));
  }
}

class MyTitleTextfieldV3 extends FormField<String> {
  MyTitleTextfieldV3(
      {super.key,
      super.onSaved,
      super.validator,
      super.initialValue,
      super.autovalidateMode = AutovalidateMode.onUserInteraction,
      TextEditingController? controller,
      String? hintText,
      required String labelText,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType,
      double borderRadius = 6,
      EdgeInsets contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      Widget? suffix,
      Widget? prefix,
      Color fillColor = Colors.white,
      bool isReadOnly = false,
      int? maxLines,
      int? minLines,
      Color borderColor = Colors.grey,
      double elevation = 2,
      double? borderWidth = 0.5,
      bool obscureText = false})
      : super(builder: (FormFieldState<String> state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitle(state.hasError, labelText),
              _Textfield(
                hasError: state.hasError,
                controller: controller,
                hintText: hintText,
                inputFormatters: inputFormatters,
                keyboardType: keyboardType,
                onChanged: (value) {
                  state.didChange(value);
                },
                borderRadius: borderRadius,
                contentPadding: contentPadding,
                suffix: suffix,
                prefix: prefix,
                fillColor: fillColor,
                isReadOnly: isReadOnly,
                borderWidth: borderWidth,
                maxLines: maxLines,
                minLines: minLines,
                borderColor: borderColor,
                obscureText: obscureText,
              ),
              if (state.hasError) _buildErrorMessage(state.errorText),
            ],
          );
        });

  static const _errorColor = Colors.red;

  static Widget _buildTitle(bool hasError, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 2),
      child: Text(
        labelText,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: hasError ? _errorColor : MyTheme.secondaryAccentColor),
      ),
    );
  }

  static Widget _buildErrorMessage(String? errorMessage) {
    return Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline,
              color: _errorColor,
              size: 14,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                errorMessage ?? "-",
                maxLines: 9,
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: _errorColor),
              ),
            ),
          ],
        ));
  }
}

class _Textfield extends StatelessWidget {
  const _Textfield({
    Key? key,
    this.inputFormatters,
    this.controller,
    this.onChanged,
    this.hintText,
    required this.borderRadius,
    required this.contentPadding,
    this.suffix,
    this.prefix,
    this.fillColor,
    required this.isReadOnly,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.borderColor = Colors.grey,
    required this.hasError,
    required this.borderWidth,
    required this.obscureText,
  }) : super(key: key);

  //final AutovalidateMode? autoValidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;

  //final void Function(String value)? onSubmit;
  //final void Function(String? value)? onSaved;
  //final String? Function(String? value)? validator;
  final double borderRadius;
  final String? hintText;

  //final String? labelText;
  final EdgeInsets? contentPadding;
  final Widget? suffix;
  final Widget? prefix;
  final Color? fillColor;
  final Color borderColor;

  ///if [isReadOnly] is true then this field is disabled and user cant interact with it.
  final bool isReadOnly;

  final TextInputType? keyboardType;

  final int? maxLines;
  final int? minLines;

  final double? borderWidth;
  final bool hasError;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      minLines: minLines,
      enabled: !isReadOnly,
      obscureText: obscureText,
      //autovalidateMode: autoValidateMode,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      controller: controller,
      onChanged: onChanged,
      //onSaved: onSaved,
      //validator: validator,
      //onFieldSubmitted: onSubmit,
      style: GoogleFonts.inter(color: _textColor, fontWeight: FontWeight.w500, fontSize: 16),
      cursorColor: _focusedBorderColor,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: _fillColor,
        filled: true,
        isDense: true,
        hintText: hintText,
        contentPadding: contentPadding,
        prefixIcon: prefix,
        suffixIcon: suffix,
        labelStyle: GoogleFonts.inter(color: MyTheme.primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
        border: _inputBorder,
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder,
      ),
    );
  }

  Color get _textColor {
    if (hasError) {
      return Colors.red;
    } else {
      return MyTheme.black_85;
    }
  }

  Color get _fillColor {
    if (hasError) {
      return Colors.red.withOpacity(0.1);
    } else {
      return fillColor ?? Colors.red;
    }
  }

  Color get _borderColor {
    if (hasError) {
      return Colors.red;
    } else {
      return borderColor;
    }
  }

  Color get _focusedBorderColor {
    if (hasError) {
      return Colors.red;
    } else {
      return MyTheme.primaryColor;
    }
  }

  InputBorder get _inputBorder {
    if (borderWidth == null) {
      return InputBorder.none;
    } else {
      return OutlineInputBorder(
        borderSide: BorderSide(color: _borderColor, width: borderWidth!),
        borderRadius: BorderRadius.circular(borderRadius),
      );
    }
  }

/*double? get _borderWidth {
    if (hasError) {
      return borderWidth;
    } else {
      return borderWidth;
    }
  }*/
}

class TextFieldWithCountry extends StatelessWidget {
  const TextFieldWithCountry({
    Key? key,
    this.initialValue,
    this.autoValidateMode,
    this.inputFormatters,
    this.controller,
    this.onChanged,
    this.validator,
    this.hintText,
    this.labelText,
    this.borderRadius = 4,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    this.suffix,
    this.prefix,
    this.fillColor = Colors.white,
    this.onSubmit,
    this.isReadOnly = false,
    this.floatingLabelBehavior,
    this.maxLines,
    this.onSaved,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  final String? initialValue;
  final AutovalidateMode? autoValidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final void Function(PhoneNumber value)? onChanged;
  final void Function(PhoneNumber value)? onSubmit;
  final void Function(PhoneNumber? value)? onSaved;
  final String? Function(PhoneNumber? value)? validator;
  final double borderRadius;
  final String? hintText;
  final String? labelText;
  final EdgeInsets? contentPadding;
  final Widget? suffix;
  final Widget? prefix;
  final Color? fillColor;
  final Color borderColor;

  ///if [isReadOnly] is true then this field is disabled and user cant interact with it.
  final bool isReadOnly;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final int? maxLines;

  static const borderWidth = 0.5;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      textAlign: TextAlign.start,
      initialValue: initialValue,
      initialCountryCode: 'KE',
      dropdownIconPosition: IconPosition.trailing,
      flagsButtonPadding: const EdgeInsets.only(left: 8),
      disableLengthCheck: true,
      enabled: !isReadOnly,
      autovalidateMode: autoValidateMode,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.phone,
      inputFormatters: inputFormatters,
      controller: controller,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      style: GoogleFonts.inter(color: MyTheme.black_85, fontWeight: FontWeight.w500, fontSize: 16),
      decoration: InputDecoration(
        floatingLabelBehavior: floatingLabelBehavior,
        fillColor: fillColor,
        filled: true,
        isDense: true,
        hintText: hintText,
        labelText: labelText,
        contentPadding: contentPadding,
        prefixIcon: prefix,
        suffixIcon: suffix,
        labelStyle: GoogleFonts.inter(color: MyTheme.primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyTheme.primaryColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class TitleWrapper extends StatelessWidget {
  const TitleWrapper({Key? key, required this.title, required this.child}) : super(key: key);
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildTitle(title), child],
    );
  }

  Widget _buildTitle(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 2),
      child: Text(
        labelText,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: MyTheme.secondaryAccentColor),
      ),
    );
  }
}

enum MyTextFieldState { focused, error, unfocused }

class ProfileTextField extends StatefulWidget {
  const ProfileTextField(
      {Key? key,
      this.icon,
      required this.title,
      this.controller,
      this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      this.maxLine = 1,
      this.validator})
      : super(key: key);

  final Widget? icon;
  final String title;
  final TextEditingController? controller;
  final EdgeInsets? margin;
  final int maxLine;
  final String? Function(String? value)? validator;

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  MyTextFieldState _textFieldState = MyTextFieldState.unfocused;

  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  Color get _borderColor {
    switch (_textFieldState) {
      case MyTextFieldState.focused:
        return MyTheme.primaryColor;
      case MyTextFieldState.error:
        return Colors.redAccent;
      case MyTextFieldState.unfocused:
        return MyTheme.grey_153;
    }
  }

  Widget _buildTextField(FormFieldState<String> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: MyTheme.black_85),
        ),
        FocusScope(
          onFocusChange: (isFocused) {
            setState(() {
              _textFieldState = isFocused ? MyTextFieldState.focused : MyTextFieldState.unfocused;
            });
          },
          child: Focus(
            child: TextField(
              focusNode: _focusNode,
              maxLines: widget.maxLine,
              controller: widget.controller,
              onChanged: (value) {
                state.setValue(value);
                state.validate();
              },
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: MyTheme.black_34),
              decoration: const InputDecoration(
                isDense: true,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 8),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _formFieldContainer({required Widget child, required FormFieldState<String> state}) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor, width: 2)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            margin: widget.margin,
            child: child,
          ),
          if (state.hasError)
            Padding(
              padding: EdgeInsets.only(left: widget.margin?.left ?? 0),
              child: Text(
                state.errorText ?? "Invalid Field",
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.redAccent),
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(validator: (value) {
      return widget.validator?.call(value);
    }, builder: (state) {
      _textFieldState = state.hasError ? MyTextFieldState.error : MyTextFieldState.unfocused;
      Widget child;
      if (widget.icon == null) {
        child = _buildTextField(state);
      } else {
        child = Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 12),
              child: widget.icon!,
            ),
            Expanded(
                child: Container(
                    decoration:
                        const BoxDecoration(border: Border(left: BorderSide(color: MyTheme.white_204, width: 2))),
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildTextField(state)))
          ],
        );
      }

      return _formFieldContainer(child: child, state: state);
    });
  }
}

