import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class OkOutlinedButtonTheme {
  OkOutlinedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TColors.secondary,
      side: const BorderSide(color: TColors.secondary),
      padding: const EdgeInsets.symmetric(vertical: Sizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular( Sizes.borderRadiusLg)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TColors.borderLight,
      side: const BorderSide(color: Colors.white),
      padding: const EdgeInsets.symmetric(vertical: Sizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular( Sizes.borderRadiusLg)),
    ),
  );
}
