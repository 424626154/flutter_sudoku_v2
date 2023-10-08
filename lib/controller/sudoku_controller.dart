

import 'package:flutter_sudoku_v2/models/board_model.dart';
import 'package:flutter_sudoku_v2/utils/logger_util.dart';
import 'package:get/get.dart';

import '../sudoku/difficulty_levels.dart';
import '../sudoku/sudoku_manager.dart';

class SudokuController extends GetxController {
  BoardModel? chessboardModel;

  List<String> fills = ['1','2','3','4','5','6','7','8','9'];

  int? pX;
  int? pY;

  int? gX;
  int? gY;
  ///草稿
  bool? isDraft ;

  void onTap({required int? gX,required int? gY,required int? pX,required int? pY}){
    this.gX = gX;
    this.gY = gY;
    this.pX = pX;
    this.pY = pY;
    update();
  }

  void initBoard(){
    SudokuManager.instance?.init();
    List<List<String>>? board = SudokuManager.instance?.getBoard(DifficultyLevels.inhuman);
    if((board ?? []).isEmpty){
      LoggerUtil.e('getBoard board isEmpty');
      return;
    }
    chessboardModel = BoardModel();
    chessboardModel?.initBoard(board ?? []);
    isDraft = false;
    update();
  }

  void getCandidates(){
    String? boardStr = chessboardModel?.boardToStr();
    List<List<String>>? board =  SudokuManager.instance?.getCandidatesFromStr(boardStr);
    // print('board:$board');
    chessboardModel?.setCandidates(board ?? []);
    update();
  }

  void onSelect(String value){
    if(isDraft ?? false){
      chessboardModel?.onDraft(pX,pY,value);
    }else{
      chessboardModel?.onFillIn(pX,pY,value);
    }

    update();
  }
  ///擦除
  void onErase(){
    chessboardModel?.onClear(pX,pY);
    update();
  }

  void onSetDraft(){
    isDraft = !(isDraft ?? false);
    update();
  }

}