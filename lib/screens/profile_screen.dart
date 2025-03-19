import 'package:elderly_care/provider/auth_provier.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/my_user.dart';
import '../my_theme.dart';
import '../utils/dialog.dart';
import '../utils/validators.dart';
import '../widgets/appbar.dart';
import '../widgets/buttons.dart';
import '../widgets/dialogs.dart';
import '../widgets/dropdown.dart';
import '../widgets/image_picker.dart';
import '../widgets/textfield_v2.dart';
import 'change_password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  final MyUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _genderList = ["Male", "Female", "Other"];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _date = TextEditingController(),
      _name = TextEditingController(),
      _email = TextEditingController(),
      _address = TextEditingController(),
      _mobileNumber = TextEditingController();

  static const _textFieldMargins = EdgeInsets.symmetric(vertical: 12.0);

  String? _selectedGender;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setValue();
    });
  }

  _setValue() {
    _name.text = widget.user.name ?? "";
    _email.text = widget.user.email ?? "";
    _mobileNumber.text = widget.user.mobile ?? "";
    _date.text = widget.user.dateOfBirth ?? "";

    _address.text = widget.user.address ?? "";

    if (widget.user.gender != null && widget.user.gender!.isNotEmpty) {
      _selectedGender = widget.user.gender ?? _genderList.first;
    }

    debugPrint('Debug _ProfileScreenState._setValue : ${widget.user.uid} ');

    setState(() {});
  }

  @override
  void dispose() {
    _date.dispose();
    _address.dispose();
    _name.dispose();
    _email.dispose();
    _mobileNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Profile",
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _ImageSection(
                name: widget.user.name,
                imageUrl: widget.user.imageUrl,
                imagePath: imagePath,
                onImageSelected: _onImageSelected,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: _textFieldMargins,
                        child: MyTitleTextfieldV3(
                            initialValue: _name.text,
                            labelText: 'Name',
                            controller: _name,
                            prefix: const Icon(FontAwesomeIcons.signature),
                            validator: MyValidator.validateName),
                      ),
                      TitleWrapper(
                          title: 'Gender',
                          child: MyDropdownV2(
                              selectedValue: _selectedGender,
                              items: _genderList,
                              prefixIcon: const Icon(Icons.person),
                              onChanged: (value) {
                                _selectedGender = value;
                              },
                              validator: (value) => MyValidator.defaultValidator(value))),
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
                                validator: (value) => MyValidator.defaultValidator(value)),
                          ),
                        ),
                      ),
                      MyTitleTextfieldV3(
                          initialValue: _email.text,
                          labelText: 'Email',
                          controller: _email,
                          prefix: const Icon(Icons.email),
                          validator: MyValidator.validateEmail),
                      Padding(
                        padding: _textFieldMargins,
                        child: MyTitleTextfieldV3(
                            initialValue: _mobileNumber.text,
                            labelText: 'Mobile Number',
                            controller: _mobileNumber,
                            prefix: const Icon(Icons.contact_emergency),
                            validator: MyValidator.validateMobileNumber),
                      ),
                      MyTitleTextfieldV3(
                        initialValue: _address.text,
                        labelText: 'Address',
                        controller: _address,
                        prefix: const Icon(Icons.location_on_rounded),
                        validator: (value) => MyValidator.defaultValidator(value),
                      ),
                      PrimaryButton.expanded(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            _onUpdateUser();
                          }
                        },
                        text: "Update Account",
                        margin: const EdgeInsets.only(top: 24),
                      ),


                      MyFlatButton(
                        minimumSize: const Size.fromHeight(0),
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
                        },
                        text: "Change Password",
                        margin: const EdgeInsets.only(top: 24),
                      ),

                     /* Padding(
                        padding: const EdgeInsets.only(top:16.0),
                        child: RichText(
                            text: TextSpan(
                                text: "Change Password",
                                style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: MyTheme.grey_102),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
                                  })),
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onImageSelected(String? path) {
    imagePath = path;
    setState(() {});
  }

  void _onUpdateUser() {
    final user = MyUser(
        uid: null,
        name: _name.text,
        gender: _selectedGender,
        email: _email.text,
        mobile: _mobileNumber.text,
        dateOfBirth: _date.text,
        address: _address.text,
        role: widget.user.role,
        lastLat: 0,
        lastLong: 0,
        imageUrl: null,
        deviceToken: "");

    MyLoadingDialog.show(context, "Updating Profile...");
    context.read<AuthProvider>().updateUser(user, imagePath).then((value) {
      MyLoadingDialog.close(context).then((_) {
        if (value.success) {
          showDialog(
              context: context,
              builder: (_) => SuccessDialog(
                    header: "Success",
                    message: "Profile updated successfully",
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
    });
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({Key? key, this.imagePath, this.imageUrl, this.name, this.onImageSelected}) : super(key: key);

  final String? imagePath;
  final String? imageUrl;
  final String? name;
  final void Function(String path)? onImageSelected;

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
        ProfileImageWithPicker(imagePath: imagePath, imageUrl: imageUrl, onImageSelected: onImageSelected, name: name)
      ],
    );
  }
}
