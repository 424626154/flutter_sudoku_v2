import 'dart:math';

void main() {
  generateSudoku(3); // 生成简单难度的数独
  generateSudoku(5); // 生成中等难度的数独
  generateSudoku(7); // 生成困难难度的数独
}

void generateSudoku(int difficultyLevel) {
  int emptyCells = 81 - difficultyLevel * 2; // 计算空白单元格数量
  List<List<int>> sudoku = List.generate(9, (_) => List.filled(9, 0)); // 创建9x9的数独网格

  // 填充已知数字
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      if (sudoku[i][j] == 0) {
        int num = Random().nextInt(9) + 1;
        while (!isValid(sudoku, i, j, num)) {
          num = Random().nextInt(9) + 1;
        }
        sudoku[i][j] = num;
        emptyCells--;
      }
    }
  }

  // 填充空白单元格
  while (emptyCells > 0) {
    int row = Random().nextInt(9);
    int col = Random().nextInt(9);
    int num = Random().nextInt(9) + 1;
    if (isValid(sudoku, row, col, num)) {
      sudoku[row][col] = num;
      emptyCells--;
    }
  }

  // 输出数独网格
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      print(sudoku[i][j]);
    }
    print( ' end: ');
  }
}

bool isValid(List<List<int>> sudoku, int row, int col, int num) {
  // 检查行是否已包含该数字
  for (int i = 0; i < 9; i++) {
    if (sudoku[row][i] == num) {
      return false;
    }
  }

  // 检查列是否已包含该数字
  for (int i = 0; i < 9; i++) {
    if (sudoku[i][col] == num) {
      return false;
    }
  }

  // 检查3x3子网格是否已包含该数字
  int startRow = (row ~/ 3) * 3;
  int startCol = (col ~/ 3) * 3;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (sudoku[startRow + i][startCol + j] == num) {
        return false;
      }
    }
  }

  return true; // 该位置可以放置该数字
}