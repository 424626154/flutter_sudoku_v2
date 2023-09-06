
import 'sudoku_group_model.dart';
import 'sudoku_model.dart';

///棋盘
class ChessboardModel {
    List<List<SudukuGroupMode>> chessboard = [];
    int rowNum = 9;
    int cellNum = 3;

    void initChessboard(List<List<int>> data){
        var groupLen = rowNum/cellNum;
        for(int i = 0;i < groupLen ; i ++){
            List<SudukuGroupMode> groupList = [];
            for(int j = 0;j < groupLen ; j ++){
                var group = SudukuGroupMode(gX: j,gY: i,cellNum: cellNum);
                groupList.add(group);
            }
            chessboard.add(groupList);
        }
        // if(data != null&&data.length == rowNum){
        //     for (int i = 0 ; i < data.length ; i ++) {
        //         var row = data[i];
        //         for(int j = 0 ; j < row.length ; j ++){
        //             var column = row[j];
        //             var pX = i;
        //             var pY = j;
        //             var gX = (j/cellNum).truncate();
        //             var gY = (i/cellNum).truncate();
        //             var value = column;
        //             var sudoku = SudokuModel(value:value,pX:pX,pY:pY,gX:gX,gY:gY);
        //         }
        //     }
        // }
    }
}