import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latest_movies/core/constants/colors.dart';
import 'package:latest_movies/core/services/shared_preferences_service.dart';
import 'package:latest_movies/core/utilities/design_utility.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/shared_widgets/app_keyboard/numeric_keyboard.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

/// FOR [ADULT CONTENT] ONLY
///
/// This dialog is used to enter the passcode to access adult content
///
/// Returns [true] if the passcode is correct in the navigator response
class EnterPasscodeDialog extends StatefulHookConsumerWidget {
  const EnterPasscodeDialog({super.key});

  @override
  ConsumerState<EnterPasscodeDialog> createState() =>
      _EnterPasscodeDialogState();
}

class _EnterPasscodeDialogState extends ConsumerState<EnterPasscodeDialog> {
  late final passcodeCtrl = TextEditingController();
  bool isPasscodeCorrect = false;

  StreamController<ErrorAnimationType> errorAnimationController =
      StreamController<ErrorAnimationType>();

  @override
  void dispose() {
    super.dispose();
    passcodeCtrl.dispose();
    errorAnimationController.close();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kBackgroundColor,
      child: FocusScope(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Enter passcode to access adult content"),
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
                    disabledColor: kPrimaryColor.withOpacity(.45),
                  ),
                  cursorColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  keyboardType: const TextInputType.numberWithOptions(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: errorAnimationController,
                  onCompleted: (v) {},
                  onChanged: (String value) {},
                ),
              ),
              if (mounted &&
                  passcodeCtrl.text.length == 4 &&
                  !isPasscodeCorrect) ...[
                const Text(
                  "Incorrect Password",
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                verticalSpaceSmall,
              ],
              Center(
                child: NumericKeyboard(
                  autofocus: true,
                  mainAxisAlignment: MainAxisAlignment.center,
                  maxLength: 4,
                  onValueChanged: (newVal) {
                    passcodeCtrl.text = newVal;
                    isPasscodeCorrect = false;
                    if (passcodeCtrl.text.length == 4) {
                      String passcode = ref
                              .read(sharedPreferencesServiceProvider)
                              .sharedPreferences
                              .getString(SharedPreferencesService
                                  .adultContentPasscode) ??
                          "";
                      if (passcodeCtrl.text == passcode) {
                        isPasscodeCorrect = true;
                      } else {
                        errorAnimationController.add(ErrorAnimationType.shake);
                      }
                    }
                    setState(() {});
                    if (isPasscodeCorrect) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
