import 'package:elderly_care/provider/auth_provier.dart';
import 'package:elderly_care/utils/url_launcher_utils.dart';
import 'package:elderly_care/widgets/appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_theme.dart';
import '../utils/dialog.dart';
import '../utils/validators.dart';
import '../widgets/buttons.dart';
import '../widgets/dialogs.dart';
import '../widgets/ripple_effect_widget.dart';
import '../widgets/textfield_v2.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '',
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Reset Password",
                style: TextStyle(fontSize: 32, color: MyTheme.black_34, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              const Text(
                "Enter the email associated with your account and we'll send an email with instruction to rest your password",
                style: TextStyle(
                  fontSize: 16,
                  color: MyTheme.black_85,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 24),
                child: Form(
                  key: _formKey,
                  child: MyTitleTextfieldV2(
                    labelText: 'Email address',
                    hintText: "Enter Email",
                    prefix: const Icon(Icons.email),
                    controller: _email,
                    validator: MyValidator.validateEmail,
                  ),
                ),
              ),
              PrimaryButton.expanded(
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true) {
                    await context.read<AuthProvider>().sendResetEmail(_email.text).then((value) {
                      if (value.success) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EmailSentScreen()));
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => ErrorDialog(
                                  message: value.errorMessage,
                                ));
                      }
                    });
                  }
                },
                text: "Send Instructions",
                margin: EdgeInsets.zero,
                enableColor: MyTheme.secondaryAccentColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController(),
      _confirmPassword = TextEditingController(),
      _currentPassword = TextEditingController();

  bool _showPassword = false;
  bool _showCurrentPassword = false;

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    _currentPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '',
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Change password",
                  style: TextStyle(fontSize: 24, color: MyTheme.black_34, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Change your password regularly to keep it secure.\nAvoid using easily guessable information such as your name or birthdate in your password",
                  style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.black_85,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 24),
                  child: MyTitleTextfieldV2(
                    labelText: 'Current Password',
                    hintText: "Enter password",
                    obscureText: !_showCurrentPassword,
                    maxLines: 1,
                    prefix: const Icon(Icons.lock),
                    suffix: _buildCurrentPasswordIcons(),
                    controller: _currentPassword,
                    validator: MyValidator.validatePassword,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: MyTitleTextfieldV2(
                    labelText: 'New Password',
                    hintText: "Enter password",
                    obscureText: !_showPassword,
                    maxLines: 1,
                    prefix: const Icon(Icons.lock),
                    suffix: _buildPasswordIcons(),
                    controller: _password,
                    validator: MyValidator.validatePassword,
                  ),
                ),
                MyTitleTextfieldV2(
                  labelText: 'Repeat Password',
                  hintText: "Enter password",
                  obscureText: !_showPassword,
                  maxLines: 1,
                  prefix: const Icon(Icons.lock),
                  suffix: _buildPasswordIcons(),
                  controller: _confirmPassword,
                  validator: (value) => value == _password.text ? null : "Password does not match",
                ),
                PrimaryButton.expanded(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) _changePassword(context);
                  },
                  text: "Change Password",
                  margin: const EdgeInsets.only(top: 28),
                  enableColor: MyTheme.secondaryAccentColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordIcons() {
    if (_showPassword) {
      return MyRippleEffectWidget(onTap: _togglePassword, child: const Icon(Icons.visibility));
    } else {
      return MyRippleEffectWidget(onTap: _togglePassword, child: const Icon(Icons.visibility_off));
    }
  }

  Widget _buildCurrentPasswordIcons() {
    if (_showPassword) {
      return MyRippleEffectWidget(onTap: _toggleCurrentPassword, child: const Icon(Icons.visibility));
    } else {
      return MyRippleEffectWidget(onTap: _toggleCurrentPassword, child: const Icon(Icons.visibility_off));
    }
  }

  void _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleCurrentPassword() {
    setState(() {
      _showCurrentPassword = !_showCurrentPassword;
    });
  }

  void _changePassword(BuildContext context) {
    MyLoadingDialog.show(context, "Updating Password...");
    context.read<AuthProvider>().changePasswordAndLogOut(_currentPassword.text, _password.text).then((value) {
      MyLoadingDialog.close(context).then((_) {
        if (value.success) {
          showDialog(
              context: context,
              builder: (_) => SuccessDialog(
                    header: "Success",
                    message: "Password updated successfully",
                    onNeutralTap: () {
                      Navigator.pop(_);
                      Navigator.pop(context);
                      /*Navigator.pushAndRemoveUntil(
                          _, MaterialPageRoute(builder: (_) => const AppNavigator()), (route) => false);*/
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
    }).catchError((e) {
      debugPrint('Debug _ChangePasswordScreenState._changePassword : $e');
    });
  }
}

class EmailSentScreen extends StatelessWidget {
  const EmailSentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.20),
              Container(
                  decoration:
                      const BoxDecoration(color: MyTheme.lightGray, borderRadius: BorderRadius.all(Radius.circular(8))),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.mark_email_read_rounded,
                    color: MyTheme.secondaryAccentColor,
                    size: 48,
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16),
                child: Text(
                  "Check you mail",
                  style: TextStyle(fontSize: 24, color: MyTheme.black_34, fontWeight: FontWeight.w700),
                ),
              ),
              const Text(
                "We have sent a password recover \ninstruction to your email",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: MyTheme.black_85, fontWeight: FontWeight.w600),
              ),
              PrimaryButton(
                onPressed: () {
                  UrlLauncherUtil().openMail();
                },
                text: "Open email app",
                margin: const EdgeInsets.only(top: 24, bottom: 12),
                enableColor: MyTheme.secondaryAccentColor,
              ),
              MyFlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Skip, I'll confirm later",
                margin: const EdgeInsets.only(top: 8, bottom: 12),
              ),
              const Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Did not receive the email? Check your spam filter.\nor ',
                  style: const TextStyle(fontSize: 12, color: MyTheme.black_85, fontWeight: FontWeight.w600),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'try another email address',
                        style: const TextStyle(
                            fontSize: 12, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
