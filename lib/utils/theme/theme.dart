import 'package:eye_prescription/utils/theme/custom_themes/appbar_theme.dart' as appBarTheme;
import 'package:eye_prescription/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:eye_prescription/utils/theme/custom_themes/checkbox_theme.dart' as checkBoxTheme;
import 'package:eye_prescription/utils/theme/custom_themes/elevated_button_theme.dart' as elevatedButtonTheme;
import 'package:eye_prescription/utils/theme/custom_themes/text_field_theme.dart' as textFieldTheme;
import 'package:eye_prescription/utils/theme/custom_themes/text_theme.dart' as textTheme;
import 'package:flutter/material.dart';

class OkAppTheme {

  OkAppTheme._();


  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme.OkAppBarTheme.lightAppBarTheme,
    checkboxTheme: checkBoxTheme.OkCheckboxTheme.lightCheckboxTheme,
    textTheme: textTheme.OkTextTheme.lightTextTheme,
    elevatedButtonTheme: elevatedButtonTheme.OkElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: textFieldTheme.OkTextFormFieldTheme.lightInputDecorationTheme,
    
    
   
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: appBarTheme.OkAppBarTheme.darkAppBarTheme,
    checkboxTheme: checkBoxTheme.OkCheckboxTheme.darkCheckboxTheme,
    textTheme: textTheme.OkTextTheme.darkTextTheme,
    elevatedButtonTheme: elevatedButtonTheme.OkElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: textFieldTheme.OkTextFormFieldTheme.darkInputDecorationTheme,

    
    );  

  
}