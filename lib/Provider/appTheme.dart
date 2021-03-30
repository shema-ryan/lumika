import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppTheme extends ChangeNotifier{
  bool _light = true ;
  ThemeData appTheme(){
    return _light ? ThemeData(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Color(0xffE8B44A),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0.5,
          onPrimary: Colors.white,
          primary: const Color(0xffE8B44A),
          textStyle: GoogleFonts.aBeeZee(
            fontSize: 18,
          )

        )
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: GoogleFonts.aBeeZee().copyWith(
          fontSize: 20,
          color: const Color(0xffE8B44A),
        ),
        contentTextStyle: GoogleFonts.aBeeZee().copyWith(
          color: Colors.black54
        )
      ),
      dividerTheme: divideTheme(),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.black,
        labelColor: const Color(0xffE8B44A),
        labelStyle: GoogleFonts.aBeeZee(
          fontSize: 16
        ),
        unselectedLabelStyle: GoogleFonts.arefRuqaa(
          fontSize: 16
        )
      ),
      accentColor: const Color(0xFFA0906E),
      primaryColor: const Color(0xffE8B44A),
      textTheme: _textTheme(),
    ):ThemeData(
      dividerTheme: divideTheme(),
      accentColor: const Color(0xFFA0906E),
      primaryColor: const Color(0xffE8B44A),
      brightness: Brightness.dark,
      textTheme: _textTheme(),
    );
  }

  void changeTheme(){
    _light = ! _light;
    notifyListeners();
  }
  static DividerThemeData divideTheme(){
    return const DividerThemeData(
      color: Colors.black
    );
  }

  static  TextTheme _textTheme(){
    return GoogleFonts.aBeeZeeTextTheme().copyWith(
      headline1:GoogleFonts.aBeeZee(),
      headline2:GoogleFonts.aBeeZee(),
        headline3:GoogleFonts.aBeeZee(),
        headline4:GoogleFonts.aBeeZee(),
        headline5:GoogleFonts.aBeeZee(),
        headline6:GoogleFonts.aBeeZee(),
    );
  }

}