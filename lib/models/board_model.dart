import 'dart:collection';

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

  ///机会次数
  int errorNumber = 0;
  static const int maxErrorNumber = 5;

  void initBoard(List<List<String>> data, List<List<String>> solveBoard) {
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
    if (data.length == rowNum) {
      for (int i = 0; i < data.length; i++) {
        var row = data[i];
        for (int j = 0; j < row.length; j++) {
          var column = row[j];
          var pX = j;
          var pY = i;
          var gX = (j / cellNum).truncate();
          var gY = (i / cellNum).truncate();
          var value = column;
          // var sudoku = SudokuModel(value:value,pX:pX,pY:pY,gX:gX,gY:gY);
          // SudukuGroupMode gropup = board[gY][gX];
          SudokuModel? sudoku = getSudokuModel(pX, pY);
          sudoku?.value = value;
          sudoku?.solve = solveBoard[i][j];
        }
      }
    }
    LoggerUtil.d('initBoard:$data');
  }

  void setCandidates(List<List<String>> data) {
    if (data.length == rowNum) {
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
      var key = '${px}_$py';
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
      boardStr += value.value;
    });
    // print('boardStr:$boardStr');
    return boardStr;
  }

  SudokuModel? getSudokuModel(int px, int py) {
    SudokuModel? sudoku;
    var gX = (px / cellNum).truncate();
    var gY = (py / cellNum).truncate();
    SudukuGroupMode gropup = board[gY][gX];
    var itemX = (px % cellNum).truncate();
    var itemY = (py % cellNum).truncate();
    sudoku = gropup.gropup[itemY][itemX];
    return sudoku;
  }

  compareToFromInt(int keys1, int keys2) {
    return keys1 > keys2;
  }

  ///返回结果 对错
  void onFillIn(int? pX, int? pY, String value) {
    SudokuModel? sudoku = getSudokuModel(pX ?? 0, pY ?? 0);
    if (sudoku?.value == SudokuGenerator.blankChar) {
      sudoku?.select = value;
      if (sudoku?.value == SudokuGenerator.blankChar &&
          sudoku?.select != sudoku?.solve &&
          sudoku?.select != SudokuGenerator.blankChar) {
        errorNumber += 1;
      }
    } else {}
  }

  void onDraft(int? pX, int? pY, String value) {
    SudokuModel? sudoku = getSudokuModel(pX ?? 0, pY ?? 0);
    if (sudoku?.value == SudokuGenerator.blankChar) {
      if (sudoku?.draftMap.containsKey(value) ?? false) {
        sudoku?.draftMap.remove(value);
      } else {
        sudoku?.draftMap[value] = value;
      }
    } else {}
  }

  void onClear(int? pX, int? pY) {
    SudokuModel? sudoku = getSudokuModel(pX ?? 0, pY ?? 0);
    if (sudoku?.select.isNotEmpty ?? false) {
      sudoku?.select = SudokuGenerator.blankChar;
    } else {}
  }

  void onSolve(List<List<String>> data) {
    if (data.length == rowNum) {
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
          if (sudoku?.value == SudokuGenerator.blankChar &&
              sudoku?.select == SudokuGenerator.blankChar) {
            sudoku?.solve = value;
          }
        }
      }
    }
  }

  bool checkGameOver() {
    bool isGameOver = true;
    for (var items in board) {
      for (var item in items) {
        bool isGroupCorrect = item.checkGroupCorrect();
        if (isGroupCorrect == false) {
          isGameOver = false;
          return isGameOver;
        }
      }
    }
    return isGameOver;
  }

  bool onTips(int? pX, int? pY) {
    bool isTips = false;
    SudokuModel? sudoku = getSudokuModel(pX ?? 0, pY ?? 0);
    if (sudoku?.value == SudokuGenerator.blankChar) {
      if (sudoku?.select != sudoku?.solve) {
        sudoku?.select = sudoku?.solve ?? SudokuGenerator.blankChar;
        isTips = true;
      } else {}
    }
    return isTips;
  }
}
