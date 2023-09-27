// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
//
// import 'models/sudoku_generator_model.dart';
//
// class SudokuGenerator {
//
//
//   SudokuGeneratorModel? sudoku ;
//   var ROWS = "ABCDEFGHI";         // Row lables
//   var COLS = '123456789';       // Column lables
//   var SQUARES = null;             // Square IDs
//
//
//   var UNITS = null;               // All units (row, column, or box)
//   var SQUARE_UNITS_MAP = null;    // Squares -> units map
//   var SQUARE_PEERS_MAP = null;    // Squares -> peers map
//
//
//
//   SudokuGenerator(){
//     sudoku = SudokuGeneratorModel();  // Global reference to the sudoku library
//     sudoku?.digits = "123456789"; // Allowed sudoku.DIGITS
//
//     // Blank character and board representation
//     sudoku?.blank_char = '.';
//     sudoku?.blank_board = "...................................................."+
//         ".............................";
//   }
//
//
//
//
//
//   // Init
//   // -------------------------------------------------------------------------
//   void initialize(){
//     /* Initialize the Sudoku library (invoked after library load)
//         */
//     SQUARES             = sudoku?.cross(ROWS, COLS);
//     UNITS               = sudoku?.get_all_units(ROWS, COLS);
//     SQUARE_UNITS_MAP    = sudoku?.get_square_units_map(SQUARES, UNITS);
//     SQUARE_PEERS_MAP    = sudoku?.get_square_peers_map(SQUARES,
//         SQUARE_UNITS_MAP);
//   }
//
//
//
//
//
// }
//
