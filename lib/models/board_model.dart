import 'dart:collection';

import 'package:flutter_sudoku_v2/sudoku/sudoku_manager.dart';
import 'package:flutter_sudoku_v2/utils/logger_util.dart';

import '../sudoku/sudoku_generator.dart';
import 'sudoku_group_model.dart';
import 'sudoku_model.dart';

///棋盘
class BoardModel {
  List<List<String>>? data;
  List<List<SudukuGroupMode>> board = [];
  int rowNum = 9;
  int cellNum = 3;

  void initBoard(List<List<String>> data) {
    this.data = data;
    var groupLen = rowNum / cellNum;
    for (int i = 0; i < groupLen; i++) {
      List<SudukuGroupMode> groupList = [];
      for (int j = 0; j < groupLen; j++) {
        var group = SudukuGroupMode(gX: j, gY: i, cellNum: cellNum);
        groupList.add(group);
      }
      board.add(groupList);
    }
    if (data != null && data.length == rowNum) {
      for (int i = 0; i < data.length; i++) {
        var row = data[i];
        for (int j = 0; j < row.length; j++) {
          var column = row[j];
          var pX = i;
          var pY = j;
          var gX = (j / cellNum).truncate();
          var gY = (i / cellNum).truncate();
          var value = column;
          // var sudoku = SudokuModel(value:value,pX:pX,pY:pY,gX:gX,gY:gY);
          // SudukuGroupMode gropup = board[gY][gX];
          SudokuModel? sudoku = getSudokuModel(pX, pY);
          sudoku?.value = value;
        }
      }
    }
    LoggerUtil.d('initBoard:$data');
  }

  void setCandidates(List<List<String>> data){
      if (data != null && data.length == rowNum) {
          for (int i = 0; i < data.length; i++) {
              var row = data[i];
              for (int j = 0; j < row.length; j++) {
                  var column = row[j];
                  var pX = i;
                  var pY = j;
                  var gX = (j / cellNum).truncate();
                  var gY = (i / cellNum).truncate();
                  var value = column;
                  // var sudoku = SudokuModel(value:value,pX:pX,pY:pY,gX:gX,gY:gY);
                  // SudukuGroupMode gropup = board[gY][gX];
                  SudokuModel? sudoku = getSudokuModel(pX, pY);
                  sudoku?.candidates = value;
              }
          }
      }
  }

  String? boardToStr() {
    Map<String, int> tempIndexMap = {};
    for (var i = 0; i < 81; i++) {
      var px = i % 9;
      var py = (i / 9).truncate();
      var key = '${px}_${py}';
      // print('key:$key-index:$i');
      tempIndexMap[key] = i;
    }
    // print(board);
    Map<String, SudokuModel> tempBoardMap = {};
    for (var gColumns in board) {
      for (var gRow in gColumns) {
        var gropup = gRow.gropup;
        for (var iColumns in gropup) {
          for (var iRow in iColumns) {
            var key = '${iRow.pX}_${iRow.pY}';
            var value = iRow.value;
            tempBoardMap[key] = iRow;
          }
        }
      }
    }
    Map<int, SudokuModel> temp1BoardMap = {};
    tempBoardMap.forEach((key, value) {
      var key = '${value.pX}_${value.pY}';
      var indexKey = tempIndexMap[key];
      temp1BoardMap[indexKey ?? 0] = value;
    });
    final sortedValuesAsc = SplayTreeMap<int, SudokuModel>.from(temp1BoardMap);
    String boardStr = '';
    sortedValuesAsc.forEach((key, value) {
        boardStr += value.value ?? '';
    });
    // print('boardStr:$boardStr');
    return boardStr;
  }

  SudokuModel? getSudokuModel(int px, int py) {
    SudokuModel? sudoku;
    if (board != null) {
      var gX = (px / cellNum).truncate();
      var gY = (py / cellNum).truncate();
      SudukuGroupMode gropup = board[gY][gX];
      if (gropup != null) {
        var itemX = (px % cellNum).truncate();
        var itemY = (py % cellNum).truncate();
        sudoku = gropup.gropup[itemY][itemX];
      }
    }
    return sudoku;
  }

  compareToFromInt(int keys1, int keys2) {
    return keys1 > keys2;
  }

  void onFillIn(int? pX,int? pY,String value) {
    SudokuModel? sudoku = getSudokuModel(pX ?? 0, pY ?? 0);
    if(sudoku?.value == SudokuGenerator.blankChar){
      sudoku?.select = value;
    }else{

    }
  }

  void onDraft(int? pX,int? pY,String value) {
    SudokuModel? sudoku = getSudokuModel(pX ?? 0, pY ?? 0);
    if(sudoku?.value == SudokuGenerator.blankChar){
      if(sudoku?.draftMap.containsKey(value) ?? false){
        sudoku?.draftMap.remove(value);
      }else{
        sudoku?.draftMap[value] = value;
      }

    }else{

    }
  }
  void onClear(int? pX,int? pY) {
    SudokuModel? sudoku = getSudokuModel(pX ?? 0, pY ?? 0);
    if(sudoku?.select?.isNotEmpty ?? false){
      sudoku?.select = SudokuGenerator.blankChar;
    }else{

    }
  }

}
