

import 'package:flutter_sudoku_v2/utils/logger_util.dart';

class SudokuModel {
  int? pX;
  int? pY;

  int? gX;
  int? gY;

  int? value;

  SudokuModel({required this.value,required this.pX,required this.pY,required this.gX,required this.gY}){
    LoggerUtil.d(toString());
  }

  @override
  String toString() {
    return {
      'value':value,
      'pX':pX,
      'pY':pY,
      'gX':gX,
      'gY':gY
    }.toString();
  }
}