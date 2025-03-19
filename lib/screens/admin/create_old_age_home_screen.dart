import 'package:elderly_care/models/old_age_home.dart';
import 'package:elderly_care/provider/admin_ui_state.dart';
import 'package:elderly_care/utils/validators.dart';
import 'package:elderly_care/widgets/appbar.dart';
import 'package:elderly_care/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../utils/dialog.dart';
import '../../widgets/buttons.dart';
import '../../widgets/textfield_v2.dart';

class CreateOldAgeHomeScreen extends StatefulWidget {
  const CreateOldAgeHomeScreen({Key? key, this.home}) : super(key: key);
  final OldAgeHome? home;

  @override
  State<CreateOldAgeHomeScreen> createState() => _CreateOldAgeHomeScreenState();
}

class _CreateOldAgeHomeScreenState extends State<CreateOldAgeHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(),
      _contactNumber = TextEditingController(),
      _email = TextEditingController(),
      _description = TextEditingController(),
      _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setHomeData();
    });
  }

  void _setHomeData() {
    if (widget.home != null) {
      _name.text = widget.home!.name;
      _contactNumber.text = widget.home!.contactNumber;
      _email.text = widget.home!.email;
      _description.text = widget.home!.description;
      _address.text = widget.home!.address;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _contactNumber.dispose();
    _email.dispose();
    _description.dispose();
    _address.dispose();
    super.dispose();
  }

  String get _buttonText => widget.home == null ? "Create Old Age Home" : "Update Old Age Home";

  String get _appBarTitle => widget.home == null ? "Add Old Age Home" : "Update Old Age Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: _appBarTitle,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                MyTitleTextfieldV3(
                  initialValue: _name.text,
                  labelText: 'Old Age Name',
                  controller: _name,
                  prefix: const Icon(FontAwesomeIcons.signature),
                  validator: (value) => MyValidator.defaultValidator(value),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: MyTitleTextfieldV3(
                    initialValue: _contactNumber.text,
                    labelText: 'Contact Number',
                    controller: _contactNumber,
                    maxLines: 1,
                    prefix: const Icon(FontAwesomeIcons.phone),
                    validator: MyValidator.validateMobileNumber,
                  ),
                ),
                MyTitleTextfieldV3(
                  initialValue: _email.text,
                  labelText: 'Email',
                  controller: _email,
                  maxLines: 1,
                  prefix: const Icon(Icons.mail),
                  validator: MyValidator.validateEmail,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: MyTitleTextfieldV3(
                      initialValue: _description.text,
                      labelText: 'Description',
                      controller: _description,
                      minLines: 3,
                      prefix: const Icon(FontAwesomeIcons.info),
                      validator: (value) => MyValidator.defaultValidator(value),
                    )),
                MyTitleTextfieldV3(
                  initialValue: _address.text,
                  labelText: 'Address',
                  controller: _address,
                  minLines: 3,
                  prefix: const Icon(FontAwesomeIcons.mapLocation),
                  validator: (value) => MyValidator.defaultValidator(value),
                ),
                PrimaryButton.expanded(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() == true) {
                      if (widget.home == null) {
                        _createOldAge();
                      } else {
                        _updateOldAge();
                      }
                    } else {}
                  },
                  text: _buttonText,
                  margin: const EdgeInsets.only(top: 24),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  OldAgeHome _generateOldAgeHome() {
    if (widget.home != null) {
      return OldAgeHome(
          uid: widget.home!.uid,
          name: _name.text,
          description: _description.text,
          contactNumber: _contactNumber.text,
          email: _email.text,
          address: _address.text);
    } else {
      return OldAgeHome(
          uid: "",
          name: _name.text,
          description: _description.text,
          contactNumber: _contactNumber.text,
          email: _email.text,
          address: _address.text);
    }
  }

  void _createOldAge() {
    MyLoadingDialog.show(context, "Creating record...");
    context.read<AdminUiState>().createOldAgeHome(_generateOldAgeHome()).then((value) {
      MyLoadingDialog.close(context);

      if (value.success) {
        showDialog(
            context: context,
            builder: (_) => SuccessDialog(
                  header: "Success",
                  message: "OldAge Home created successfully",
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

  void _updateOldAge() {
    MyLoadingDialog.show(context, "Updating record...");
    context.read<AdminUiState>().updateOldAgeHome(_generateOldAgeHome()).then((value) {
      MyLoadingDialog.close(context);

      if (value.success) {
        showDialog(
            context: context,
            builder: (_) => SuccessDialog(
                  header: "Success",
                  message: "OldAge Home updated successfully",
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
