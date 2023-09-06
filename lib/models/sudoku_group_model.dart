import 'sudoku_model.dart';

class SudukuGroupMode {
  List<List<SudokuModel>> gropup = [];
  int? gX;
  int? gY;

  ///几乘几
  int? cellNum;

  SudukuGroupMode({required this.gX, required this.gY, required this.cellNum}) {
    for (var i = 0; i < (cellNum ?? 0); i++) {
      List<SudokuModel> rows  = [];
      for (var j = 0; j < (cellNum ?? 0); j++) {
        var pX =  (gX ?? 0)*(cellNum ?? 0)+j;
        var pY = (gY ?? 0)*(cellNum ?? 0)+i;
        var item = SudokuModel(value:0,pX: pX, pY: pY, gX: gX, gY: gY);
        rows.add(item);
      }
      gropup.add(rows);
    }
  }
}
