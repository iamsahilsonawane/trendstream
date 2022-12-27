import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/shared_widgets/button.dart';
import 'package:latest_movies/core/shared_widgets/text_field.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';

import '../../../core/services/shared_preferences_service.dart';

class SetPasscodeDialog extends HookConsumerWidget {
  const SetPasscodeDialog({super.key});

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
              const Text("Set a passcode to access adult content"),
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
                text: "Set Passcode & Enter",
                onTap: () async {
                  if (passcodeCtrl.text.isEmpty) {
                    return;
                  }

                  final navigator = Navigator.of(context);

                  await ref
                      .read(sharedPreferencesServiceProvider)
                      .sharedPreferences
                      .setString(SharedPreferencesService.adultContentPasscode,
                          passcodeCtrl.text);
                  await ref
                      .read(sharedPreferencesServiceProvider)
                      .sharedPreferences
                      .setBool(SharedPreferencesService.isPasscodeSet, true);

                  navigator.pop(true);
                },
                prefix: const Icon(Icons.password),
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
