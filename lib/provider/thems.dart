import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class themes with ChangeNotifier{
  final dartTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.purple,
    backgroundColor: Colors.black,
    accentColor: Colors.deepOrange,

    fontFamily: 'Lato',
  );
  final lightTheme=ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.purple,
    backgroundColor: Color(0xFFFF7643),
    accentColor: Colors.deepOrange,

    fontFamily: 'Lato',
  );
  ThemeData? getthemeData()=> _themeData;

  ThemeData? _themeData ;
  var is_dart;

  themes(){
    _themeData= lightTheme;
    is_dart=false;
    notifyListeners();

  }
  void setdeftMode(String mode){
    if(mode=='true') {
      _themeData = dartTheme;
      is_dart = true;
      notifyListeners();
    }
  }
  Future<void> setDartMode() async {

    _themeData =dartTheme;
    is_dart=true;
    SharedPreferences value=await SharedPreferences.getInstance();
    value.setString('mode','true');
    notifyListeners();
  }
  Future<void> setlightMode() async {
    _themeData =lightTheme;
    is_dart=false;
    SharedPreferences value=await SharedPreferences.getInstance();
    value.setString('mode','false');
    notifyListeners();
  }
}