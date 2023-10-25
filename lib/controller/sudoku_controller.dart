import 'package:flutter_sudoku_v2/models/board_model.dart';
import 'package:flutter_sudoku_v2/utils/logger_util.dart';
import 'package:get/get.dart';

import '../sudoku/difficulty_levels.dart';
import '../sudoku/sudoku_manager.dart';

class SudokuController extends GetxController {
  BoardModel? chessboardModel;

  List<String> fills = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  int? pX;
  int? pY;

  int? gX;
  int? gY;

  ///草稿
  bool? isDraft;

  ///机会次数
  int? chanceNumber;

  int? tipsNum;
  static const int maxTipsNum = 5;

  ///时长
  int? duration;
  bool isTimer = false;
  String level = DifficultyLevels.easy;

  void onTap(
      {required int? gX,
      required int? gY,
      required int? pX,
      required int? pY}) {
    this.gX = gX;
    this.gY = gY;
    this.pX = pX;
    this.pY = pY;
    update();
  }

  void setLevel(String level){
    this.level = level;
    update();
  }

  void initBoard() {
    SudokuManager.instance?.init();
    List<List<String>>? board = SudokuManager.instance?.getBoard(level);
    List<List<String>>? solveBoard = SudokuManager.instance?.solvePuzzle(board);
    if ((board ?? []).isEmpty) {
      LoggerUtil.e('getBoard board isEmpty');
      return;
    }
    LoggerUtil.d('board:$board');
    LoggerUtil.d('solveBoard:$solveBoard');
    chessboardModel = BoardModel();
    chessboardModel?.initBoard(board ?? [], solveBoard ?? []);
    isDraft = false;
    chanceNumber = 5;
    tipsNum = 0;
    duration = 0;
    update();
  }

  void getCandidates() {
    String? boardStr = chessboardModel?.boardToStr();
    List<List<String>>? board =
        SudokuManager.instance?.getCandidatesFromStr(boardStr);
    // print('board:$board');
    chessboardModel?.setCandidates(board ?? []);
    update();
  }

  void onSelect(String value, Function onGameOver) {
    if (isDraft ?? false) {
      chessboardModel?.onDraft(pX, pY, value);
    } else {
      chessboardModel?.onFillIn(pX, pY, value);
    }
    bool isGameOver = chessboardModel?.checkGameOver() ?? false;
    if (isGameOver) {
      onGameOver();
    }
    LoggerUtil.d('isGameOver:$isGameOver');
    update();
  }

  ///擦除
  void onErase() {
    chessboardModel?.onClear(pX, pY);
    update();
  }

  void onSetDraft() {
    isDraft = !(isDraft ?? false);
    update();
  }

  void onSolvePuzzle() {
    List<List<String>>? solve =
        SudokuManager.instance?.solvePuzzle(chessboardModel?.data);
    if (solve?.length == 9) {
      chessboardModel?.onSolve(solve ?? []);
    }
    update();
  }

  bool onTips() {
    if((tipsNum ?? 0) >= maxTipsNum){
      return false;
    }
    bool isTips = chessboardModel?.onTips(pX, pY) ?? false;
    if (isTips) tipsNum = (tipsNum ?? 0) + 1;
    update();
    return isTips;
  }

  void addDuration(int add) {
    duration = (duration ?? 0) + add;
    update();
  }

  void upTimer(bool timer) {
    isTimer = timer;
    update();
  }
}
