

import 'package:flutter_sudoku_v2/utils/logger_util.dart';

import '../sudoku/sudoku_generator.dart';

class SudokuModel {
  int? pX;
  int? pY;

  int? gX;
  int? gY;
  ///题目
  String value;
  ///用户选择结果
  late String select;
  ///草稿
  late Map<String,String> draftMap;
  ///候选
  String? _candidates;
  List<String>? candidatesList;
  Map<String,String>? candidatesMap;

  SudokuModel({required this.value,required this.pX,required this.pY,required this.gX,required this.gY}){
    // LoggerUtil.d(toString());
    select = SudokuGenerator.blankChar;
    draftMap = {};
  }

  set candidates(String? candidates){
    _candidates = candidates;
    candidatesList = _candidates?.split('');
    candidatesMap = {};
    candidatesList?.forEach((element) {
      candidatesMap![element] = element;
    });
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