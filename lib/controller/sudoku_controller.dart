

import 'package:flutter_sudoku_v2/models/chessboard_model.dart';
import 'package:get/get.dart';

class SudokuController extends GetxController {
  ChessboardModel? chessboardModel;

  int? pX;
  int? pY;

  int? gX;
  int? gY;

  void onTap({required int? gX,required int? gY,required int? pX,required int? pY}){
    this.gX = gX;
    this.gY = gY;
    this.pX = pX;
    this.pY = pY;
    update();
  }

  void initChessboard(){
    List<List<int>> data = [
      [0,1,2,3,4,5,6,7,8],
      [0,1,2,3,4,5,6,7,8],
      [0,1,2,3,4,5,6,7,8],
      [0,1,2,3,4,5,6,7,8],
      [0,1,2,3,4,5,6,7,8],
      [0,1,2,3,4,5,6,7,8],
      [0,1,2,3,4,5,6,7,8],
      [0,1,2,3,4,5,6,7,8],
      [0,1,2,3,4,5,6,7,8]
    ];
    chessboardModel = ChessboardModel();
    chessboardModel?.initChessboard(data);
  }


}