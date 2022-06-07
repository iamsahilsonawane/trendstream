import 'package:flutter/material.dart';

import '../shared/button.dart';
import '../shared/text_field.dart';
import '../utilities/design_utility.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Continue where you left off',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold),
                  ),
                  verticalSpaceSmall,
                  Text(
                    "Sign in to continue using the app",
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
                        'Username/Email: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const AppTextField(
                        prefixIcon: Icon(Icons.email),
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
                      const AppTextField(
                        prefixIcon: Icon(Icons.password),
                        isPassword: true,
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Continue',
                      onTap: () {},
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
    );
  }
}
