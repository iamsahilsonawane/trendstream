import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/_app_router.dart';
import '../../constants/constants.dart';
import '../../utilities/app_utility.dart';
import '../../utilities/design_utility.dart';
import '../auth/auth_viewmodel.dart';
import 'button.dart';
import 'default_app_padding.dart';
import 'text_field.dart';

class AppDialogs {
  static Future<dynamic>? showAppDialog(context, List<Widget> children) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: DefaultAppPadding(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        );
      },
    );
  }

  static Future<dynamic>? showForgotPasswordDialog(context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    bool isLoading = false;
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.grey[900],
            width: MediaQuery.of(context).size.width / 3,
            child: Consumer(
              builder: (context, ref, child) => DefaultAppPadding(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text( "Alert",
                      //   style: GoogleFonts.poppins(
                      //       fontSize: 16, fontWeight: FontWeight.w600),
                      // ),
                      // AppUtils.verticalSpacer,
                      // Image(
                      //   image: AssetImage(AppPaths.alertSign),
                      //   width: AppUtils.screenWidth(context) * .4,
                      // ),
                      // AppUtils.verticalSpacer,
                      const Text(
                        AppStrings.resetPassword,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      verticalSpaceMedium,
                      const Text(
                        AppStrings.wellSendEmailPasswordReset,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      verticalSpaceMedium,
                      AppTextField(
                        // prefixIconPath: AppPaths.emailIcon,
                        prefixIcon: const Icon(Icons.email, size: 18),
                        controller: emailController,
                        validator: AppUtils.emailValidate,
                        hintText: AppStrings.enterYourEmail,
                      ),
                      verticalSpaceMedium,
                      StatefulBuilder(
                        builder: (context, setState) => SizedBox(
                          width: double.infinity,
                          child: AppButton.secondary(
                            text: AppStrings.sendEmail,
                            isLoading: isLoading,
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() => isLoading = true);
                                try {
                                  await ref
                                      .read(authVMProvider)
                                      .sendPasswordResetEmail(
                                          emailController.text.trim());
                                  setState(() => isLoading = false);
                                  AppRouter.pop(AppStrings.emailSent);
                                } catch (e) {
                                  setState(() => isLoading = false);
                                  AppRouter.pop();
                                  rethrow;
                                }
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
