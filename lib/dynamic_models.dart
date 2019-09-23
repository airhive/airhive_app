import 'package:flutter/cupertino.dart';

class MapStyleModel with ChangeNotifier{
  int _currStyle;

  getStyle() => _currStyle;

  void setStyle(int newstyle){
    _currStyle = newstyle;
    notifyListeners();
  }
}