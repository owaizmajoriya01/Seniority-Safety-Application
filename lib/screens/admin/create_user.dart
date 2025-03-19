import 'package:elderly_care/models/my_user.dart';
import 'package:elderly_care/models/old_age_home.dart';
import 'package:elderly_care/provider/admin_ui_state.dart';
import 'package:elderly_care/utils/dialog.dart';
import 'package:elderly_care/utils/validators.dart';
import 'package:elderly_care/widgets/appbar.dart';
import 'package:elderly_care/widgets/buttons.dart';
import 'package:elderly_care/widgets/dropdown.dart';
import 'package:elderly_care/widgets/textfield_v2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../my_theme.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/ripple_effect_widget.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _genderList = ["Male", "Female", "Other"];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _date = TextEditingController(),
      _name = TextEditingController(),
      _email = TextEditingController(),
      _password = TextEditingController(),
      _address = TextEditingController(),
      _mobileNumber = TextEditingController();

  bool _showPassword = false;

  //UserType _selectedUsertype = UserType.values.first;

  static const _textFieldMargins = EdgeInsets.symmetric(vertical: 12.0);

  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    /* if (widget.userType != null) {
      _selectedUsertype = widget.userType!;
    }*/
  }

  @override
  void dispose() {
    _date.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _address.dispose();
    _mobileNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Create Account",
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Form(
              key:_formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* TitleWrapper(
                    title: 'Account for :',
                    child: _UserTypeSelector(
                      initialValue: _selectedUsertype,
                      onSelectionChange: (userType) {
                        _selectedUsertype = userType;
                      },
                    ),
                  ),*/
                  Padding(
                    padding: _textFieldMargins,
                    child: MyTitleTextfieldV3(
                        labelText: 'Name',
                        controller: _name,
                        prefix: const Icon(FontAwesomeIcons.signature),
                        validator: MyValidator.validateName),
                  ),
                  TitleWrapper(
                      title: 'Gender',
                      child: MyDropdownV2(
                          items: _genderList,
                          prefixIcon: const Icon(Icons.person),
                          onChanged: (value) {
                            _selectedGender = value;
                          },
                          validator: (value) =>
                              MyValidator.defaultValidator(value))),
                  Padding(
                    padding: _textFieldMargins,
                    child: GestureDetector(
                      onTap: () async {
                        var currentTime = DateTime.now();
                        DateTime? date = await showDialog(
                          context: context,
                          builder: (_) => DatePickerDialog(
                              initialDate: DateTime(currentTime.year - 17),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(currentTime.year - 17)),
                        );
                        if (date != null) {
                          DateFormat df = DateFormat("yyyy-MM-dd");
                          _date.text = df.format(date);
                        }
                      },
                      child: TitleWrapper(
                        title: "Date of Birth",
                        child: MyTextFieldV2(
                            prefix: const Icon(Icons.calendar_month),
                            hintText: "Date of birth",
                            controller: _date,
                            isReadOnly: true,
                            validator: (value) =>
                                MyValidator.defaultValidator(value)),
                      ),
                    ),
                  ),
                  MyTitleTextfieldV3(
                      labelText: 'Email',
                      controller: _email,
                      prefix: const Icon(Icons.email),
                      validator: MyValidator.validateEmail),
                  Padding(
                    padding: _textFieldMargins,
                    child: MyTitleTextfieldV3(
                        labelText: 'Mobile Number',
                        controller: _mobileNumber,
                        prefix: const Icon(Icons.contact_emergency),
                        validator: MyValidator.validateMobileNumber),
                  ),
                  MyTitleTextfieldV3(
                    labelText: 'Address',
                    controller: _address,
                    prefix: const Icon(Icons.location_on_rounded),
                    validator: (value)=>MyValidator.defaultValidator(value),
                  ),
                  Padding(
                    padding: _textFieldMargins,
                    child: MyTitleTextfieldV3(
                      labelText: 'Password',
                      hintText: "Enter password",
                      controller: _password,
                      obscureText: !_showPassword,
                      maxLines: 1,
                      prefix: const Icon(Icons.lock),
                      suffix: _buildPasswordIcons(),
                      validator: MyValidator.validatePassword,
                    ),
                  ),
                  PrimaryButton.expanded(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _onCreateUser();
                      }
                    },
                    text: "Create Account",
                    margin: const EdgeInsets.only(top: 24),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordIcons() {
    if (_showPassword) {
      return MyRippleEffectWidget(
          onTap: _togglePassword, child: const Icon(Icons.visibility));
    } else {
      return MyRippleEffectWidget(
          onTap: _togglePassword, child: const Icon(Icons.visibility_off));
    }
  }

  void _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _onCreateUser() {
    final user = MyUser(
        uid: null,
        name: _name.text,
        gender: _selectedGender,
        email: _email.text,
        mobile: _mobileNumber.text,
        dateOfBirth: _date.text,
        address: _address.text,
        role: UserRoleEnum.caretaker.name,
        lastLat: 0,
        lastLong: 0,
        imageUrl: null,
        deviceToken: "");

    MyLoadingDialog.show(context, "Creating caretaker account...");
    context.read<AdminUiState>().createUser(user, _password.text).then((value) {
      MyLoadingDialog.close(context);
      if (value.success) {
        showDialog(
            context: context,
            builder: (_) => SuccessDialog(
                  header: "Success",
                  message: "Caretaker account created successfully",
                  onNeutralTap: () {
                    Navigator.pop(_);
                    Navigator.pop(context);
                  },
                ));
      } else {
        showDialog(
            context: context,
            builder: (_) => ErrorDialog(
                  message: value.errorMessage,
                ));
      }
    });
  }
}

enum UserType { elder, caretaker }

extension _UserTypeConverter on UserType {
  UserRoleEnum get toUserRoleEnum {
    switch (this) {
      case UserType.elder:
        return UserRoleEnum.elder;
      case UserType.caretaker:
        return UserRoleEnum.caretaker;
    }
  }
}

class _UserTypeSelector extends StatefulWidget {
  const _UserTypeSelector(
      {Key? key, required this.onSelectionChange, this.initialValue})
      : super(key: key);
  final void Function(UserType usertype) onSelectionChange;
  final UserType? initialValue;

  @override
  State<_UserTypeSelector> createState() => _UserTypeSelectorState();
}

class _UserTypeSelectorState extends State<_UserTypeSelector> {
  final List<bool> _isSelected = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      var index = UserType.values.indexOf(widget.initialValue!);
      _isSelected
          .addAll(List.generate(UserType.values.length, (i) => i == index));
    } else {
      _isSelected
          .addAll(List.generate(UserType.values.length, (index) => index == 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
        onPressed: (index) {
          for (int i = 0; i < _isSelected.length; i++) {
            _isSelected[i] = i == index;
          }
          widget.onSelectionChange.call(UserType.values.firstWhere(
              (element) => element.index == index,
              orElse: () => UserType.elder));
          setState(() {});
        },
        borderRadius: BorderRadius.circular(4),
        constraints: const BoxConstraints(),
        selectedColor: MyTheme.primaryColor,
        textStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.8),
        selectedBorderColor: MyTheme.primaryColor,
        isSelected: _isSelected,
        children: const [
          ///before adding additional children, add them in [_UserType] enum first.

          _ToggleButton(
            title: "Elder",
            icon: Icon(
              FontAwesomeIcons.personCane,
              size: 20,
            ),
          ),
          _ToggleButton(
            title: "Caretaker",
            icon: Icon(
              FontAwesomeIcons.handsHoldingChild,
              size: 20,
            ),
            padding: EdgeInsets.only(left: 12),
          ),
        ]);
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton(
      {Key? key,
      required this.title,
      required this.icon,
      this.padding = const EdgeInsets.only(left: 4.0)})
      : super(key: key);
  final String title;
  final Widget icon;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
      child: Row(
        children: [
          icon,
          Padding(
            padding: padding,
            child: Text(title),
          )
        ],
      ),
    );
  }
}

class AddElderScreen extends StatefulWidget {
  const AddElderScreen({Key? key}) : super(key: key);

  @override
  State<AddElderScreen> createState() => _AddElderScreenState();
}

class _AddElderScreenState extends State<AddElderScreen> {
  final _genderList = ["Male", "Female", "Other"];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _date = TextEditingController(),
      _name = TextEditingController(),
      _email = TextEditingController(),
      _password = TextEditingController(),
      _address = TextEditingController(),
      _oldAgeHome = TextEditingController(),
      _mobileNumber = TextEditingController();

  bool _showPassword = false;
  static const _textFieldMargins = EdgeInsets.symmetric(vertical: 12.0);

  String? _selectedGender;
  MyUser? _selectedCaretaker;
  OldAgeHome? _selectedOldAgeHome;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _date.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _address.dispose();
    _oldAgeHome.dispose();
    _mobileNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Create Elder Account",
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: _textFieldMargins,
                    child: MyTitleTextfieldV3(
                        labelText: 'Name',
                        controller: _name,
                        prefix: const Icon(FontAwesomeIcons.signature),
                        validator: MyValidator.validateName),
                  ),
                  TitleWrapper(
                      title: 'Gender',
                      child: MyDropdownV2(
                          items: _genderList,
                          prefixIcon: const Icon(Icons.person),
                          onChanged: (value) {
                            _selectedGender = value;
                          },
                          validator: (value) =>
                              MyValidator.defaultValidator(value))),
                  Padding(
                    padding: _textFieldMargins,
                    child: GestureDetector(
                      onTap: () async {
                        var currentTime = DateTime.now();
                        DateTime? date = await showDialog(
                          context: context,
                          builder: (_) => DatePickerDialog(
                              initialDate: DateTime(currentTime.year - 17),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(currentTime.year - 17)),
                        );
                        if (date != null) {
                          DateFormat df = DateFormat("yyyy-MM-dd");
                          _date.text = df.format(date);
                        }
                      },
                      child: TitleWrapper(
                        title: "Date of Birth",
                        child: MyTextFieldV2(
                          prefix: const Icon(Icons.calendar_month),
                          hintText: "Date of birth",
                          controller: _date,
                          isReadOnly: true,
                          validator: (value) =>
                              MyValidator.defaultValidator(value),
                        ),
                      ),
                    ),
                  ),
                  MyTitleTextfieldV3(
                    labelText: 'Email',
                    controller: _email,
                    prefix: const Icon(Icons.email),
                    validator: MyValidator.validateEmail,
                  ),
                  Padding(
                    padding: _textFieldMargins,
                    child: MyTitleTextfieldV3(
                      labelText: 'Mobile Number',
                      controller: _mobileNumber,
                      prefix: const Icon(Icons.contact_emergency),
                      validator: MyValidator.validateMobileNumber,
                    ),
                  ),
                  MyTitleTextfieldV3(
                    labelText: 'Address',
                    controller: _address,
                    prefix: const Icon(Icons.location_on_rounded),
                    validator: (value)=>MyValidator.defaultValidator(value),
                  ),
                  Padding(
                    padding: _textFieldMargins,
                    child: MyTitleTextfieldV3(
                      labelText: 'Password',
                      hintText: "Enter password",
                      controller: _password,
                      obscureText: !_showPassword,
                      maxLines: 1,
                      prefix: const Icon(Icons.lock),
                      suffix: _buildPasswordIcons(),
                      validator: MyValidator.validatePassword,
                    ),
                  ),
                  TitleWrapper(
                      title: 'Caretaker',
                      child: Consumer<AdminUiState>(
                          builder: (context, provider, child) {
                        return MyDropdownV3(
                          items: provider.caretakerList,
                          prefixIcon: const Icon(Icons.person),
                          onChanged: (value) {
                            _selectedCaretaker = value;
                          },
                          validator: (value) =>
                              MyValidator.defaultValidator(value?.name),
                        );
                      })),

                  Padding(
                    padding: _textFieldMargins,
                    child: TitleWrapper(
                        title: 'Old Age Home',
                        child: Consumer<AdminUiState>(
                            builder: (context, provider, child) {
                              return MyDropdownV2<OldAgeHome>(
                                items: provider.oldAgeHomeList,
                                prefixIcon: const Icon(Icons.home),
                                onChanged: (value) {
                                  _selectedOldAgeHome = value;
                                },
                                validator: (value) =>
                                    MyValidator.defaultValidator(value?.name),
                              );
                            })),
                  ),
                  PrimaryButton.expanded(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _onCreateUser();
                      }
                    },
                    text: "Create Account",
                    margin: const EdgeInsets.only(top: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordIcons() {
    if (_showPassword) {
      return MyRippleEffectWidget(
          onTap: _togglePassword, child: const Icon(Icons.visibility));
    } else {
      return MyRippleEffectWidget(
          onTap: _togglePassword, child: const Icon(Icons.visibility_off));
    }
  }

  void _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _onCreateUser() {
    final user = MyUser(
        uid: null,
        name: _name.text,
        gender: _selectedGender,
        email: _email.text,
        mobile: _mobileNumber.text,
        dateOfBirth: _date.text,
        address: _address.text,
        role: UserRoleEnum.elder.name,
        lastLat: 0,
        lastLong: 0,
        imageUrl: null,
        assignedOldAge: _selectedOldAgeHome?.name,
        deviceToken: "");

    MyLoadingDialog.show(context, "Creating Elder account...");
    context
        .read<AdminUiState>()
        .createElder(user, _password.text, _selectedCaretaker!)
        .then((value) {
      MyLoadingDialog.close(context);
      if (value.success) {
        showDialog(
            context: context,
            builder: (_) => SuccessDialog(
                  header: "Success",
                  message: "Elder account created successfully",
                  onNeutralTap: () {
                    Navigator.pop(_);
                    Navigator.pop(context);
                  },
                ));
      } else {
        showDialog(
            context: context,
            builder: (_) => ErrorDialog(
                  message: value.errorMessage,
                ));
      }
    });
  }
}
