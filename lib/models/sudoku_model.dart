
import '../sudoku/sudoku_generator.dart';

class SudokuModel {
  int? pX;
  int? pY;

  int? gX;
  int? gY;
  ///题目
  late String value;
  ///用户选择结果
  late String select;
  ///程序自动生成结果
  late String solve;
  ///草稿
  late Map<String,String> draftMap;
  ///候选
  String? _candidates;
  List<String>? candidatesList;
  Map<String,String>? candidatesMap;

  SudokuModel({required this.value,required this.pX,required this.pY,required this.gX,required this.gY}){
    // LoggerUtil.d(toString());
    solve = select = SudokuGenerator.blankChar;
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
  ///判断是否争取
  bool checkCorrect(){
    bool isCorrect = false;
    if(value == SudokuGenerator.blankChar){
      if(select == solve && solve != SudokuGenerator.blankChar){
        isCorrect = true;
      }
    }else{
      isCorrect = true;
    }
    return isCorrect;
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