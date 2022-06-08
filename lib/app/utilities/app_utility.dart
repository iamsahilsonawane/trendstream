import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'dart:math' as math;

import 'design_utility.dart';

class AppUtils {
  static bool emailValidation(String value) {
    final validEmail = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return validEmail.hasMatch(value);
  }

  static String? fieldEmpty(String? value) {
    if (value!.isNotEmpty) {
      return null;
    } else {
      return AppStrings.fieldCanNotBeEmpty;
    }
  }

  static String? emailValidate(String? value) {
    if (value!.isNotEmpty) {
      if (emailValidation(value.trim())) {
        return null;
      } else {
        return AppStrings.invalidEmail;
      }
    } else {
      return AppStrings.enterYourEmail;
    }
  }

  static String? passwordValidate(String? value) {
    if (value!.isNotEmpty) {
      if (value.length < 6) {
        return AppStrings.passwordValidation;
      } else {
        return null;
      }
    } else {
      return AppStrings.enterYourPassword;
    }
  }

  static String? passwordValidateWithEquality(String? value, String? value2) {
    if (value!.isNotEmpty) {
      if (value.length < 6) {
        return AppStrings.passwordValidation;
      } else if (value != value2) {
        return AppStrings.passwordsNotMatch;
      } else {
        return null;
      }
    } else {
      return AppStrings.enterYourPassword;
    }
  }

  static String? phoneValidate(String? value) {
    if (value!.isNotEmpty) {
      if (value.length < 10 || value.length > 10) {
        return AppStrings.invalidPhoneNumber;
      } else {
        return null;
      }
    } else {
      return AppStrings.fieldCanNotBeEmpty;
    }
  }

  static Future<void> getDatePicker(BuildContext context,
      {required DateTime initialDate,
      required Function(DateTime date) onDatePicked,
      DateTime? firstDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return child ?? const SizedBox.shrink();
      },
    );
    if (picked != null && picked != initialDate) onDatePicked(picked);
  }

  static Future<void> getTimePicker(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay timeOfDay) onTimePicked) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != initialTime) {
      onTimePicked(pickedTime);
    }
  }

  ///Creates a super secure password with given input
  static String generatePassword({
    bool letter = true,
    bool numbersInclusive = true,
    bool specialInclusive = true,
    bool onlyUppercase = false,
    int length = 20,
  }) {
    assert(length >= 6);
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';

    String chars = "";
    if (letter) {
      if (onlyUppercase) {
        chars += letterUpperCase;
      } else {
        chars += '$letterLowerCase$letterUpperCase';
      }
    }

    if (numbersInclusive) chars += number;
    if (specialInclusive) chars += special;

    return List.generate(length, (index) {
      final indexRandom = math.Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  static void unfocusAll(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static String resolveImageUrl(String? url) {
    if (url == null) {
      return 'https://source.unsplash.com/random';
    }
    if ((url.contains(".jpg") ||
            url.contains(".png") ||
            url.contains(".jpeg")) &&
        url.contains("http")) {
      return url;
    } else {
      return 'https://source.unsplash.com/random';
    }
  }

  static String? resolveAwsURL(String? url) {
    if (url == null) {
      return null;
    }

    if (!(url.contains(".jpg") ||
        url.contains(".png") ||
        url.contains(".jpeg") ||
        url.contains(".mp4") ||
        url.contains(".mov"))) {
      return AppUtils.resolveImageUrl(url);
    }

    if (url.contains("http")) {
      return url;
    }
    return 'https://topofficial.s3.ap-south-1.amazonaws.com/$url';
  }

  static String resolveString(String? str, {bool blankOnNull = false}) {
    if (str != null) {
      return str;
    } else {
      if (blankOnNull) {
        return "";
      }
      return 'N/A';
    }
  }

  static void showSnackBar(
    BuildContext? context, {
    String? message,
    Color color = Colors.black87,
    Icon? icon,
  }) {
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          icon ?? const SizedBox.shrink(),
          if (icon != null) horizontalSpaceTiny,
          Text(message ?? AppStrings.somethingWentWrong),
        ],
      ),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(20),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showNotImplementedSnackBar(BuildContext context) {
    AppUtils.showSnackBar(
      context,
      message: "Not implemented yet",
      icon: const Icon(
        Icons.error,
        color: Colors.lightBlue,
        size: 20,
      ),
    );
  }

  ///Generates readable text from total seconds passed in as parameter
  ///
  ///@param **[n]** is the total number of seconds
  ///
  ///For example:
  ///`convertSecondstoTimeframe(2000)` returns _"33 minutes"_
  static String convertSecondstoTimeframe(int n) {
    var day = n / (24 * 3600);

    n = n % (24 * 3600);
    var hour = n / 3600;

    n %= 3600;
    var minutes = n / 60;

    n %= 60;
    var seconds = n;

    if (day >= 1) {
      return "${day.round()} days ${hour.round()} hours ${minutes.round()} minutes ";
    } else if (hour >= 1) {
      return "${hour.round()} hours ${minutes.round()} minutes ";
    } else if (minutes >= 1) {
      return "${minutes.round()} minutes ";
    } else {
      return "${seconds.round()} seconds ";
    }
  }

  // static shareText(String text, {String? subject}) {
  //   Share.share(text, subject: subject);
  // }

  // static Future<void> openUrl(String url) async {
  //   if (!await launch(url)) throw 'Could not launch $url';
  // }
}

class AppDebouncer {
  final int milliseconds;
  late VoidCallback action;
  Timer? _timer;

  AppDebouncer({this.milliseconds = 300});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
