import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/router/router.dart';
import 'package:latest_movies/core/shared_widgets/button.dart';
import 'package:latest_movies/core/shared_widgets/text_field.dart';
import 'package:latest_movies/core/utilities/app_utility.dart';

import '../../../core/constants/constants.dart';
import '../../../core/shared_widgets/popups.dart';
import '../../../core/utilities/design_utility.dart';
import '../controllers/auth_controller.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final authModel = ref.watch(authVMProvider);

    ref.listen<AuthViewModel>(authVMProvider, (_, model) async {
      if (model.error != null) {
        AppUtils.showSnackBar(context,
            message: model.error.message.toString(),
            color: Colors.white,
            icon: const Icon(Icons.error, color: Colors.red, size: 20));
        model.error = null;
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: formKey,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text(
                              "Forgot Password",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onPressed: () async {
                              final result =
                                  await AppDialogs.showForgotPasswordDialog(
                                      context);
                              if (result != null) {
                                if (result == AppStrings.emailSent) {
                                  // ignore: use_build_context_synchronously
                                  AppUtils.showSnackBar(context,
                                      message: 'Email sent successfully!',
                                      color: Colors.white,
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 20,
                                      ));
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: 'Continue',
                          isLoading: authModel.isLoading,
                          onTap: () {
                            if (formKey.currentState?.validate() ?? false) {
                              authModel.signInWithEmail(
                                context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            }
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
                        child: AppButton(
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
      ),
    );
  }
}
