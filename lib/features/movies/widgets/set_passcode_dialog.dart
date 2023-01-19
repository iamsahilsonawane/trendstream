import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../core/shared_widgets/app_keyboard/numeric_keyboard.dart';

class SetPasscodeDialog extends HookConsumerWidget {
  const SetPasscodeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passcodeCtrl = useTextEditingController();

    return Dialog(
      backgroundColor: kBackgroundColor,
      child: FocusScope(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Set a passcode to access adult content"),
              verticalSpaceRegular,

              Center(
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: passcodeCtrl,
                  obscureText: false,
                  autoFocus: false,
                  beforeTextPaste: (text) => false,
                  readOnly: true,
                  animationType: AnimationType.fade,
                  enabled: false,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    activeFillColor: kPrimaryColor,
                    activeColor: Colors.transparent,
                    inactiveFillColor: Colors.transparent,
                    inactiveColor: kPrimaryColor,
                    selectedFillColor: kPrimaryColor.withOpacity(.2),
                    disabledColor: kPrimaryColor,
                  ),
                  cursorColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  keyboardType: const TextInputType.numberWithOptions(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {},
                  onChanged: (String value) {},
                ),
              ),
              Center(
                child: NumericKeyboard(
                  autofocus: true,
                  mainAxisAlignment: MainAxisAlignment.center,
                  maxLength: 4,
                  onValueChanged: (newVal) {
                    passcodeCtrl.text = newVal;
                  },
                  onDoneTap: () async {
                    if (passcodeCtrl.text.isEmpty) {
                      return;
                    }

                    final navigator = Navigator.of(context);

                    await ref
                        .read(sharedPreferencesServiceProvider)
                        .sharedPreferences
                        .setString(
                            SharedPreferencesService.adultContentPasscode,
                            passcodeCtrl.text);
                    await ref
                        .read(sharedPreferencesServiceProvider)
                        .sharedPreferences
                        .setBool(SharedPreferencesService.isPasscodeSet, true);

                    navigator.pop(true);
                  },
                ),
              ),
              // AppButton(
              //   text: "Set Passcode & Enter",
              //   onTap: () async {

              //   },
              //   prefix: const Icon(Icons.password),
              //   focusNode: btnFocusNode,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
