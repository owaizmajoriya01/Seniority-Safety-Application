import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../models/my_user.dart';
import '../my_theme.dart';

import '../utils/pair.dart';
import 'textfield_v2.dart';

///FIXME: [DropDownWithOther] is bloated , refactor this class.

///dropdown widget which will show another textField when "other" is selected in dropdown
class DropDownWithOther extends StatefulWidget {
  const DropDownWithOther(
      {Key? key,
      this.onSaved,
      this.validator,
      this.autovalidateMode,
      required this.otherController,
      this.otherValidator,
      required this.items,
      this.selectedValue,
      this.onChanged,
      this.labelText,
      this.hintText,
      this.formOnSaved})
      : super(key: key);

  final void Function(String? value)? onSaved;
  final void Function(Pair<String?, String?>)? formOnSaved;
  final void Function(String? value)? onChanged;
  final String? Function(String? value)? validator;
  final String? Function(String? value)? otherValidator;
  final List<String> items;
  final String? selectedValue;
  final String? labelText;
  final String? hintText;
  final AutovalidateMode? autovalidateMode;

  ///controller for text field when "other" is selected in dropdown
  final TextEditingController otherController;

  @override
  State<DropDownWithOther> createState() => _DropDownWithOtherState();
}

class _DropDownWithOtherState extends State<DropDownWithOther> {
  String? _selectedShopType;

  @override
  Widget build(BuildContext context) {
    return FormField<Pair<String?, String?>>(
        autovalidateMode: widget.autovalidateMode,
        onSaved: (value) {
          if (value == null || value.first?.toLowerCase() != "other") {
            widget.otherController.text = "";
          }
          widget.formOnSaved?.call(Pair(value?.first, widget.otherController.text));
        },
        builder: (state) {
          return Column(
            children: [
              MyDropdownV2<String>(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: widget.labelText,
                hintText: widget.hintText,
                autoValidateMode: widget.autovalidateMode,
                items: widget.items,
                selectedValue: widget.selectedValue,
                onChanged: (value) {
                  _selectedShopType = value;
                  widget.onChanged?.call(value);
                },
                validator: widget.validator,
                onSaved: (value) {
                  if (value?.toLowerCase() == "other") {
                    widget.otherController.text = "";
                  }
                  state.didChange(Pair(value, widget.otherController.text));
                },
              ),
              if (_selectedShopType.toString().toLowerCase() == "other")
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                  child: MyTextFieldV2(
                    autoValidateMode: widget.autovalidateMode,
                    //contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    hintText: "Other",
                    labelText: "Other",
                    controller: widget.otherController,
                    validator: widget.otherValidator,
                    onSaved: (remarkValue) {
                      state.didChange(Pair(_selectedShopType, remarkValue));
                    },
                  ),
                )
            ],
          );
        });
  }
}

class MyDropdownV2<T> extends StatefulWidget {
  const MyDropdownV2(
      {Key? key,
      required this.items,
      this.autoValidateMode,
      this.onChanged,
      this.validator,
      this.borderRadius = 4,
      this.hintText,
      this.labelText,
      this.contentPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      this.fillColor = Colors.white,
      this.isReadOnly = false,
      this.selectedValue,
      this.floatingLabelBehavior,
      this.onSaved, this.prefixIcon})
      : super(key: key);

  /// [items] to be displayed in dropdown.
  ///
  /// for displaying name in dropdown [toString] method is used.
  /// if you are using custom models then override toString method of your custom class.
  final List<T> items;

  ///selected value of dropdown;
  final T? selectedValue;

  final AutovalidateMode? autoValidateMode;

  ///callback function when dropdown value is changed.
  final void Function(T? value)? onChanged;

  ///callback function when onSaved is called.
  final void Function(T? value)? onSaved;

  ///validate function
  final String? Function(T? value)? validator;

  ///border radius of dropdown textField.
  final double borderRadius;

  ///hint text when drop down is empty.
  final String? hintText;

  ///label text for dropdown.
  ///
  ///This will be visible when textfield is empty and animate to top when textfield is not empty.
  final String? labelText;

  ///textField padding.
  final EdgeInsets? contentPadding;

  ///background color of textField.
  final Color? fillColor;

  /// if [isReadOnly] is true textfield is disabled.
  ///
  /// default value is false
  final bool isReadOnly;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final Widget? prefixIcon;

  @override
  State<MyDropdownV2<T>> createState() => _MyDropdownV2State<T>();
}

class _MyDropdownV2State<T> extends State<MyDropdownV2<T>> {
  T? _currentSelectedValue;

  static const borderWidth = 0.5;

  @override
  void initState() {
    super.initState();
    _currentSelectedValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant MyDropdownV2<T> oldWidget) {
    if (oldWidget.selectedValue != widget.selectedValue) {
      _currentSelectedValue = widget.selectedValue;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
        isExpanded: true,
        validator: widget.validator,
        value: _currentSelectedValue,
        autovalidateMode: widget.autoValidateMode,
        onSaved: widget.onSaved,
        style: GoogleFonts.inter(color: MyTheme.black_85, fontWeight: FontWeight.w500, fontSize: 16),
        decoration: InputDecoration(
          enabled: !widget.isReadOnly,
          floatingLabelBehavior: widget.floatingLabelBehavior,
          fillColor: widget.fillColor,
          filled: true,
          isDense: true,
          contentPadding: widget.contentPadding,
          labelStyle: GoogleFonts.inter(color: MyTheme.primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
          hintStyle: GoogleFonts.inter(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
          prefixIcon: widget.prefixIcon,
          //errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
          labelText: widget.labelText,
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: borderWidth),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: borderWidth),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyTheme.primaryColor, width: borderWidth),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        items: widget.items.map((value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              value.toString(),
              maxLines: 1,
              //overflow: TextOverflow.clip,
            ),
          );
        }).toList(),
        onChanged: (value) {
          _currentSelectedValue = value;
          widget.onChanged?.call(value);
          setState(() {});
        });
  }
}


class MyDropdownV3 extends StatefulWidget {
  const MyDropdownV3(
      {Key? key,
        required this.items,
        this.autoValidateMode,
        this.onChanged,
        this.validator,
        this.borderRadius = 4,
        this.hintText,
        this.labelText,
        this.contentPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        this.fillColor = Colors.white,
        this.isReadOnly = false,
        this.selectedValue,
        this.floatingLabelBehavior,
        this.onSaved, this.prefixIcon})
      : super(key: key);

  /// [items] to be displayed in dropdown.
  ///
  /// for displaying name in dropdown [toString] method is used.
  /// if you are using custom models then override toString method of your custom class.
  final List<MyUser> items;

  ///selected value of dropdown;
  final MyUser? selectedValue;

  final AutovalidateMode? autoValidateMode;

  ///callback function when dropdown value is changed.
  final void Function(MyUser? value)? onChanged;

  ///callback function when onSaved is called.
  final void Function(MyUser? value)? onSaved;

  ///validate function
  final String? Function(MyUser? value)? validator;

  ///border radius of dropdown textField.
  final double borderRadius;

  ///hint text when drop down is empty.
  final String? hintText;

  ///label text for dropdown.
  ///
  ///This will be visible when textfield is empty and animate to top when textfield is not empty.
  final String? labelText;

  ///textField padding.
  final EdgeInsets? contentPadding;

  ///background color of textField.
  final Color? fillColor;

  /// if [isReadOnly] is true textfield is disabled.
  ///
  /// default value is false
  final bool isReadOnly;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final Widget? prefixIcon;

  @override
  State<MyDropdownV3> createState() => _MyDropdownV3State();
}

class _MyDropdownV3State extends State<MyDropdownV3> {
  MyUser? _currentSelectedValue;

  static const borderWidth = 0.5;

  @override
  void initState() {
    super.initState();
    _currentSelectedValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant MyDropdownV3 oldWidget) {
    if (oldWidget.selectedValue != widget.selectedValue) {
      _currentSelectedValue = widget.selectedValue;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<MyUser>(
        isExpanded: true,
        validator: widget.validator,
        value: _currentSelectedValue,
        autovalidateMode: widget.autoValidateMode,
        onSaved: widget.onSaved,
        style: GoogleFonts.inter(color: MyTheme.black_85, fontWeight: FontWeight.w500, fontSize: 16),
        decoration: InputDecoration(
          enabled: !widget.isReadOnly,
          floatingLabelBehavior: widget.floatingLabelBehavior,
          fillColor: widget.fillColor,
          filled: true,
          isDense: true,
          contentPadding: widget.contentPadding,
          labelStyle: GoogleFonts.inter(color: MyTheme.primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
          hintStyle: GoogleFonts.inter(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14),
          prefixIcon: widget.prefixIcon,
          //errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
          labelText: widget.labelText,
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: borderWidth),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: borderWidth),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyTheme.primaryColor, width: borderWidth),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        items: widget.items.map((value) {
          return DropdownMenuItem<MyUser>(
            value: value,
            child: Text(
              value.name.toString(),
              maxLines: 1,
              //overflow: TextOverflow.clip,
            ),
          );
        }).toList(),
        onChanged: (value) {
          _currentSelectedValue = value;
          widget.onChanged?.call(value);
          setState(() {});
        });
  }
}
