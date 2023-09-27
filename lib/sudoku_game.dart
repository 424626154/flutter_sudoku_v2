// import 'dart:math';
//
// import 'package:flutter_sudoku_v2/utils/logger_util.dart';
//
// class SudokuGame {
//   /*
// 		 * constants
// 		 *-----------*/
//
//   var DIFFICULTY_EASY = "easy";
//   var DIFFICULTY_MEDIUM = "medium";
//   var DIFFICULTY_HARD = "hard";
//   var DIFFICULTY_VERY_HARD = "very hard";
//   int boardSize = 9;
//   List board = [];
//
//   /*
// 		the score reflects how much increased difficulty the board gets by having the pattern rather than an already solved cell
// 		*/
//   List<Strategie> strategies = [
//     // {title: "openSingles", fn: openSingles, score: 0.1},
//     // //harder for human to spot
//     // {title: "singleCandidate", fn: singleCandidate, score: 9},
//     // {title: "visualElimination", fn: visualElimination, score: 8},
//     // //only eliminates one candidate, should have lower score?
//     // {title: "nakedPair", fn: nakedPair, score: 50},
//     // {title: "pointingElimination", fn: pointingElimination, score: 80},
//     // //harder for human to spot
//     // {title: "hiddenPair", fn: hiddenPair, score: 90},
//     // {title: "nakedTriplet", fn: nakedTriplet, score: 100},
//     // //never gets used unless above strats are turned off?
//     // {title: "hiddenTriplet", fn: hiddenTriplet, score: 140},
//     // //never gets used unless above strats are turned off?
//     // {title: "nakedQuad", fn: nakedQuad, score: 150},
//     // //never gets used unless above strats are turned off?
//     // {title: "hiddenQuad", fn: hiddenQuad, score: 280}
//   ];
//
//   //array contains function
//   bool contains(List<int> list, int item) {
//     for (var i = 0; i < list.length; i++) {
//       if (list[i] == item) {
//         return true;
//       }
//     }
//     return false;
//   }
//
//   List<int> uniqueArray(List<int> list) {
//     Map<int, bool> temp = {};
//     for (var i = 0; i < list.length; i++) {
//       temp[list[i]] = true;
//     }
//     List<int> r = [];
//     temp.forEach((key, value) {
//       r.add(key);
//     });
//     return r;
//   }
//
//   /* calcBoardDifficulty
// 		 * --------------
// 		 *  TYPE: solely based on strategies required to solve board (i.e. single count per strategy)
// 		 *  SCORE: distinguish between boards of same difficulty.. based on point system. Needs work.
// 		 * -----------------------------------------------------------------*/
//   BoardDiff calcBoardDifficulty(List<int> usedStrategies) {
//     BoardDiff boardDiff = BoardDiff();
//     if (usedStrategies.length < 3) {
//       boardDiff.level = DIFFICULTY_EASY;
//     } else if (usedStrategies.length < 4) {
//       boardDiff.level = DIFFICULTY_MEDIUM;
//     } else {
//       boardDiff.level = DIFFICULTY_HARD;
//     }
//
//     double totalScore = 0;
//     for (var i = 0; i < strategies.length; i++) {
//       var freq = usedStrategies[i];
//       // if (!freq) {
//       //   continue; //undefined or 0, won't effect score
//       // }
//       var stratObj = strategies[i];
//       totalScore += freq * (stratObj.score ?? 0);
//     }
//     boardDiff.score = totalScore;
//     //log("totalScore: "+totalScore);
//
//     if (totalScore > 750) {
//       // if(totalScore > 2200)
//       boardDiff.level = DIFFICULTY_VERY_HARD;
//     }
//     return boardDiff;
//   }
//
//   /* isBoardFinished
// 		 * -----------------------------------------------------------------*/
//   bool isBoardFinished() {
//     for (var i = 0; i < boardSize * boardSize; i++) {
//       if (board[i].val == null) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   /* generateHouseIndexList
// 		 * -----------------------------------------------------------------*/
//   void generateHouseIndexList() {
//     // reset houses
//     var houses = [
//       //hor. rows
//       [],
//       //vert. rows
//       [],
//       //boxes
//       []
//     ];
//     var boxSideSize = sqrt(boardSize);
//
//     for (var i = 0; i < boardSize; i++) {
//       var hrow = []; //horisontal row
//       var vrow = []; //vertical row
//       var box = [];
//       for (var j = 0; j < boardSize; j++) {
//         hrow.add(boardSize * i + j);
//         vrow.add(boardSize * j + i);
//
//         if (j < boxSideSize) {
//           for (var k = 0; k < boxSideSize; k++) {
//             //0, 0,0, 27, 27,27, 54, 54, 54 for a standard sudoku
//             var a = (i / boxSideSize).truncate() * boardSize * boxSideSize;
//             //[0-2] for a standard sudoku
//             var b = (i % boxSideSize) * boxSideSize;
//             var boxStartIndex = a + b; //0 3 6 27 30 33 54 57 60
//
//             //every boxSideSize box, skip boardSize num rows to next box (on new horizontal row)
//             //Math.floor(i/boxSideSize)*boardSize*2
//             //skip across horizontally to next box
//             //+ i*boxSideSize;
//
//             box.add(boxStartIndex + boardSize * j + k);
//           }
//         }
//       }
//       houses[0].add(hrow);
//       houses[1].add(vrow);
//       houses[2].add(box);
//     }
//   }
//
//
//   /* initBoard
// 		 * --------------
// 		 *  inits board, variables.
// 		 * -----------------------------------------------------------------*/
//   void initBoard(opts) {
//     // var alreadyEnhanced = (board[0] != null && typeof board[0] == "object");
//     var nullCandidateList = [];
//     var boardNumbers = [];
//     // boardSize = (!board.length && opts.boardSize) || sqrt(board.length) || 9;
//     // $board.attr("data-board-size", boardSize);
//     // if (boardSize % 1 != 0 || sqrt(boardSize) % 1 != 0) {
//     //   LoggerUtil.d("invalid boardSize:$boardSize");
//     //   if (typeof opts.boardErrorFn == "function") {
//     //     opts.boardErrorFn({msg: "invalid board size"});
//     //   }
//     //   return;
//     // }
//     for (var i = 0; i < boardSize; i++) {
//       boardNumbers.add(i + 1);
//       nullCandidateList.add(null);
//     }
//     generateHouseIndexList();
//
//     // if (!alreadyEnhanced) {
//       //enhance board to handle candidates, and possibly other params
//       // for (var j = 0; j < boardSize * boardSize; j++) {
//       //   var cellVal = (typeof board[j] == "undefined") ? null : board[j];
//       //   var candidates = cellVal == null
//       //       ? boardNumbers.slice()
//       //       : nullCandidateList.slice();
//       //   board[j] = {
//       //     val: cellVal,
//       //     candidates: candidates
//       //     //title: "" possibl add in 'A1. B1...etc
//       //   };
//       // }
//     // }
//   }
//
//
//   /* renderBoard
// 		 * --------------
// 		 *  dynamically renders the board on the screen (into the DOM), based on board variable
// 		 * -----------------------------------------------------------------*/
//   void renderBoard() {
//     //log("renderBoard");
//     //log(board);
//     var htmlString = "";
//     for (var i = 0; i < boardSize * boardSize; i++) {
//       // htmlString += renderBoardCell(board[i], i);
//
//       if ((i + 1) % boardSize == 0) {
//         htmlString += "<br>";
//       }
//     }
//     // log(htmlString);
//     // $board.append(htmlString);
//     //
//     // //save important board elements
//     // $boardInputs = $board.find("input");
//     // $boardInputCandidates = $board.find(".candidates");
//   }
//
//   /* renderBoardCell
// 		 * -----------------------------------------------------------------*/
//   void renderBoardCell(boardCell, id) {
//     var val = (boardCell.val == null) ? "" : boardCell.val;
//     var candidates ;
//     // = boardCell.candidates || [];
//     var candidatesString = buildCandidatesString(candidates);
//     var maxlength = (boardSize < 10) ? " maxlength='1'" : "";
//     // return "<div class='sudoku-board-cell'>" +
//     // //want to use type=number, but then have to prevent chrome scrolling and up down key behaviors..
//     // "<input type='text' pattern='\\d*' novalidate id='input-"+id+"' value='"+val+"'"+maxlength+">" +
//     // "<div id='input-"+id+"-candidates' class='candidates'>" + candidatesString + "</div>" +
//     // "</div>";
//   }
//
//
//   /* buildCandidatesString
// 		 * -----------------------------------------------------------------*/
//   String buildCandidatesString(candidatesList) {
//     var s = "";
//     for (var i = 1; i < boardSize + 1; i++) {
//       if (contains(candidatesList, i)) {
//         s += "<div>$i</div> ";
//       } else {
//         s += "<div>&nbsp;</div> ";
//       }
//     }
//     return s;
//   }
//
//
//   List getBoard(){
//     return board;
//   }
//
//
// }
//
// class BoardDiff {
//   String? level;
//   double? score;
// }
//
// class Strategie {
//   double? score;
// }
