import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/router.dart';
import '../../utilities/app_utility.dart';
import '../../utilities/design_utility.dart';
import '../shared/button.dart';
import '../shared/text_field.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: formKey,
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
                          'Email Address: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          controller: emailController,
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
                          controller: passwordController,
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
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Continue',
                        onTap: () {
                          formKey.currentState?.validate();
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
                        onTap: () {
                          AppRouter.navigateToPage(Routes.signUpView);
                        },
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
    );
  }
}
