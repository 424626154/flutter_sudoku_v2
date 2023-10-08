import 'package:flutter_sudoku_v2/sudoku/sudoku_generator.dart';
import 'package:flutter_sudoku_v2/utils/logger_util.dart';

class SudokuManager {
  /// 单例对象
  static SudokuManager? _instance;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  SudokuManager._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory SudokuManager() => _getInstance();

  static SudokuManager? get instance => _getInstance();

  /// 获取单例内部方法
  static _getInstance() {
    // 只能有一个实例
    _instance ??= SudokuManager._internal();
    return _instance;
  }

  SudokuGenerator? generator ;

  List<List<String>>? board;

  void init(){
    generator = SudokuGenerator();
  }

  List<List<String>>? getBoard(String puzzle){
    String? boardStr = generator?.generateFromStr(puzzle);
    if((boardStr ?? '').isEmpty){
      return null;
    }
    List<List<String>>? board = generator?.boardStrToGrid(boardStr ?? '');
    return board;
  }

  void showPuzzle(String puzzle){
    var boardStr = generator?.generateFromStr(puzzle);
    board = generator?.boardStrToGrid(boardStr ?? '');
    LoggerUtil.d(board);
  }

  void solvePuzzle(){
    String? boardStr = generator?.boardGridToStr(board ?? []);
    String? solveStr  = generator?.solve(boardStr ?? '');
    List<List<String>>? solve = generator?.boardStrToGrid(solveStr ?? '');
    solve?.forEach((element) {
      LoggerUtil.d(element);
    });
  }

  List<List<String>>? getCandidates(List<List<String>>? board,{String puzzle = 'easy'}) {
    String? boardStr = generator?.boardGridToStr(board ?? []);
    List<List<String>>? candidates = generator?.getCandidates(boardStr ?? '');
    candidates?.forEach((element) {
      LoggerUtil.d(element);
    });
    return candidates;
  }

  List<List<String>>? getCandidatesFromStr(String? boardStr,{String puzzle = 'easy'}) {
    List<List<String>>? candidates = generator?.getCandidates(boardStr ?? '');
    candidates?.forEach((element) {
      LoggerUtil.d(element);
    });
    return candidates;
  }

}
