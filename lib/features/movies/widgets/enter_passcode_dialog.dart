import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/core/shared_widgets/button.dart';
import 'package:latest_movies/core/shared_widgets/text_field.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';

/// FOR [ADULT CONTENT] ONLY
///
/// This dialog is used to enter the passcode to access adult content
///
/// Returns [true] if the passcode is correct in the navigator response
class EnterPasscodeDialog extends HookConsumerWidget {
  const EnterPasscodeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final btnFocusNode = useFocusNode();
    final passcodeCtrl = useTextEditingController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          focusNode.requestFocus();
        });
      });
      return null;
    }, []);

    return Dialog(
      backgroundColor: kBackgroundColor,
      child: FocusScope(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Enter passcode to access adult content"),
              verticalSpaceRegular,
              AppTextField(
                hintText: "Enter passcode",
                controller: passcodeCtrl,
                focusNode: focusNode,
                isPassword: true,
                onEditingComplete: () {
                  btnFocusNode.requestFocus();
                },
              ),
              verticalSpaceRegular,
              AppButton(
                text: "Access Content",
                onTap: () {
                  String passcode = ref
                          .read(sharedPreferencesServiceProvider)
                          .sharedPreferences
                          .getString(
                              SharedPreferencesService.adultContentPasscode) ??
                      "";
                  if (passcodeCtrl.text == passcode) {
                    Navigator.pop(context, true);
                  } else {
                    Navigator.pop(context, false);
                  }
                },
                prefix: const Icon(Icons.login),
                focusNode: btnFocusNode,
              ),
              AppButton(
                text: "Go Back",
                onTap: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
