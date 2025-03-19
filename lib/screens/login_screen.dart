import 'package:elderly_care/models/my_user.dart';
import 'package:elderly_care/my_theme.dart';
import 'package:elderly_care/provider/auth_provier.dart';
import 'package:elderly_care/screens/admin/admin_home_screen.dart';
import 'package:elderly_care/screens/caretaker/caretaker_home_screen.dart';
import 'package:elderly_care/screens/elder/elder_home_screen.dart';
import 'package:elderly_care/utils/dialog.dart';
import 'package:elderly_care/utils/validators.dart';
import 'package:elderly_care/widgets/buttons.dart';
import 'package:elderly_care/widgets/dialogs.dart';
import 'package:elderly_care/widgets/ripple_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../widgets/textfield_v2.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController(), _password = TextEditingController();

  bool _showPassword = false;

  static const _iconPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.offWhiteScaffoldColor,
      /* appBar: const MyAppBar(
        title: 'Sign In',
        centerTitle: true,
        showLeadingWidget: false,
        elevation: 0,
        appBarColor: MyTheme.offWhiteScaffoldColor,
        textStyle: TextStyle(
            fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w700, letterSpacing: 1.2),
      ),*/
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const FlutterLogo(),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome Back...!",
                          style: TextStyle(
                              fontSize: 24,
                              color: MyTheme.secondaryAccentColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Sign In",
                          style: TextStyle(
                              fontSize: 18,
                              color: MyTheme.accentColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2),
                        ),
                      ],
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTitleTextfieldV2(
                        labelText: 'Email',
                        hintText: "Enter Email",
                        prefix: const Icon(Icons.email),
                        controller: _email,
                        validator: MyValidator.validateEmail,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTitleTextfieldV2(
                        labelText: 'Password',
                        hintText: "Enter password",
                        obscureText: !_showPassword,
                        maxLines: 1,
                        prefix: const Icon(Icons.lock),
                        suffix: _buildPasswordIcons(),
                        controller: _password,
                        validator: MyValidator.validatePassword,
                      ),
                      Consumer<AuthProvider>(builder: (context, provider, child) {
                        return PrimaryButton.expanded(
                          onPressed: () {
                            onLoginPressed(provider);
                          },
                          text: "Sign In",
                          margin: const EdgeInsets.only(top: 32, bottom: 32),
                        );
                      }),
                    ],
                  ),
                ),
                const Text(
                  "- or sign in with -",
                  style: TextStyle(color: MyTheme.mediumGray),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Expanded(
                      child: _SocialMediaIconButton(
                          onTap: () {},
                          icon: const Padding(
                              padding: _iconPadding, child: Center(child: FaIcon(FontAwesomeIcons.apple))))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SocialMediaIconButton(
                        onTap: () {},
                        icon: const Padding(
                            padding: _iconPadding, child: Center(child: FaIcon(FontAwesomeIcons.google)))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _SocialMediaIconButton(
                          onTap: () {},
                          icon: const Padding(
                              padding: _iconPadding, child: Center(child: FaIcon(FontAwesomeIcons.facebookF))))),
                ])
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

  void _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void onLoginPressed(AuthProvider provider) {
    debugPrint('Debug _LoginScreenState.onLoginPressed : ${provider.isLoading} ');
    if (_formKey.currentState?.validate() == true && !provider.isLoading) {
      MyLoadingDialog.show(context, "Logging in");
      provider.login(_email.text, _password.text).then((value) {
        MyLoadingDialog.close(context).then((_) {
          if (value?.success == true) {
            var route = NavigationHelper().getScreenFromRole(provider.currentUser?.role);

            Navigator.push(context, MaterialPageRoute(builder: (_) => route));
          } else {
            showDialog(
                context: context,
                builder: (_) => ErrorDialog(
                      header: "Error",
                      message: value?.errorMessage,
                    ));
          }
        });
      });
    }
  }
}

class _SocialMediaIconButton extends StatelessWidget {
  const _SocialMediaIconButton({Key? key, required this.icon, required this.onTap}) : super(key: key);

  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.hardEdge,
      child: MyRippleEffectWidget(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          onTap: onTap,
          child: icon),
    );
  }
}

class NavigationHelper {
  Widget getScreenFromRole(String? role) {
    UserRoleEnum? enumRole = UserRoleEnum.values.firstWhereOrNull((element) => element.name == role);
    switch (enumRole) {
      case UserRoleEnum.elder:
        return const ElderHomeScreen();

      case UserRoleEnum.caretaker:
        return const CareTakerHomeScreen();

      case UserRoleEnum.admin:
        return const AdminHomeScreen();

      default:
        return const ElderHomeScreen();
    }
  }
}
