import 'package:flutter/material.dart';

import '../../utilities/app_utility.dart';
import '../../utilities/design_utility.dart';
import '../shared/button.dart';
import '../shared/text_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpaceMedium,
                const FlutterLogo(size: 100),
                const SizedBox(height: 40),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  constraints: const BoxConstraints(minWidth: 400),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join to watch great movies at your fingertips',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold),
                      ),
                      verticalSpaceSmall,
                      Text(
                        "Movies, series and more. You're all covered up",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      verticalSpaceMedium,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: _emailController,
                            prefixIcon: const Icon(Icons.email, size: 18),
                            validator: AppUtils.emailValidate,
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: _passwordController,
                            prefixIcon: const Icon(
                              Icons.password,
                              size: 18,
                            ),
                            isPassword: true,
                            validator: AppUtils.passwordValidate,
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirm Password: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppTextField(
                            controller: _confirmPasswordController,
                            prefixIcon: const Icon(
                              Icons.password,
                              size: 18,
                            ),
                            isPassword: true,
                            validator: (text) =>
                                AppUtils.passwordValidateWithEquality(
                                    text, _passwordController.text),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: 'Continue',
                          onTap: () {
                            _formKey.currentState?.validate();
                          },
                        ),
                      ),
                      verticalSpaceMedium,
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                            color: Colors.grey[900],
                          )),
                          const SizedBox(width: 10),
                          Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Divider(
                            color: Colors.grey[900],
                          )),
                        ],
                      ),
                      verticalSpaceMedium,
                      SizedBox(
                        width: double.infinity,
                        child: AppButton.secondary(
                          text: 'Create an account',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
