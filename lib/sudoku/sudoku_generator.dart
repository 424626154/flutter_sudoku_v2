import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_sudoku_v2/sudoku/difficulty_levels.dart';
import 'package:flutter_sudoku_v2/utils/logger_util.dart';

///参考算法 https://github.com/robatron/sudoku.js/blob/master/sudoku.js
class SudokuGenerator {
  // Define difficulties by how many squares are given to the player in a new
  // puzzle.
  // 抽离出 DifficultyLevels

  int minGivens = 17; // Minimum number of givens
  int nrSquares = 81; // Number of squares

  String digits = "123456789";
  static String blankChar = '.';
  String blankBoard =
      '.................................................................................';

  String rows = "ABCDEFGHI"; // Row lables
  String cols = '123456789'; // Column lables

  late List<String> squares;
  late List<List<String>> units;
  late Map<String, List<List<String>>> squareUnitsMap;
  late Map squarePeersMap;

  SudokuGenerator() {
    squares = cross(rows, cols);
    units = _getAllUnits(rows, cols);
    squareUnitsMap = _getSquareUnitsMap(squares, units);
    squarePeersMap = getSquarePeersMap(squares, squareUnitsMap);
  }

  ///生成数独
  String? generateFromStr(String? difficultyStr) {
    int? difficultyInt = DifficultyLevels.getDifficultyLevel(difficultyStr);
    return generate(difficultyInt);
  }

  ///生成数独
  String generate(int? difficulty, {bool unique = true}) {
    // Force difficulty between 17 and 81 inclusive
    difficulty = forceRange(difficulty, nrSquares + 1, minGivens);

    // Default unique to true
    // unique = unique || true;

    // Get a set of squares and all possible candidates for each square
    var blankBoard = "";
    for (var i = 0; i < nrSquares; ++i) {
      blankBoard += '.';
    }

    var candidates = getCandidatesMap(blankBoard);

    // For each item in a shuffled list of squares
    var shuffledSquares = _shuffle(squares);

    for (var si in shuffledSquares) {
      var square = si;
      // If an assignment of a random chioce causes a contradictoin, give
      // up and try again
      var randCandidateIdx = _randRange(candidates[square]?.length);
      var randCandidate = candidates[square]?[randCandidateIdx];
      if (_assign(candidates, square, randCandidate ?? '').isEmpty) {
        break;
      }

      // Make a list of all single candidates
      var singleCandidates = [];
      for (var si in squares) {
        var square = si;

        if (candidates[square]?.length == 1) {
          singleCandidates.add(candidates[square]);
        }
      }
      // print('single_candidates:${single_candidates.length}');
      // If we have at least difficulty, and the unique candidate count is
      // at least 8, return the puzzle!
      if (singleCandidates.length >= difficulty &&
          _stripDups(singleCandidates).length >= 8) {
        var board = "";
        List<int> givensIdxs = [];
        for (var i = 0; i < squares.length; i++) {
          var square = squares[i];
          if (candidates[square]?.length == 1) {
            board += candidates[square] ?? '';
            givensIdxs.add(i);
          } else {
            board += blankChar;
          }
        }

        // If we have more than `difficulty` givens, remove some random
        // givens until we're down to exactly `difficulty`
        var nrGivens = givensIdxs.length;
        if (nrGivens > difficulty) {
          givensIdxs = _shuffleInt(givensIdxs);
          for (var i = 0; i < nrGivens - difficulty; ++i) {
            // print('givens_idxs:${givens_idxs}');
            var target = givensIdxs[i];
            board = board.substring(0, target) +
                blankChar +
                board.substring(target + 1);
          }
        }
        // Double check board is solvable
        // TODO: Make a standalone board checker. Solve is expensive.
        if (solve(board).isNotEmpty) {
          return board;
        }
      }
    }

    // Give up and try a new puzzle
    return generate(difficulty);
  }

  List<List<String>> _getAllUnits(String rows, String cols) {
    /* Return a list of all units (rows, cols, boxes)
        */
    List<List<String>> units = [];
    List rowList = rows.split('');
    // Rows
    for (var ri in rowList) {
      units.add(cross(ri, cols));
    }
    List colsList = cols.split('');
    // Columns
    for (var ci in colsList) {
      units.add(cross(rows, ci));
    }

    // Boxes
    var rowSquares = ["ABC", "DEF", "GHI"];
    var colSquares = ["123", "456", "789"];

    for (var rsi in rowSquares) {
      for (var csi in colSquares) {
        units.add(cross(rsi, csi));
      }
    }

    return units;
  }

  Map<String, List<List<String>>> _getSquareUnitsMap(
      List<String> squares, List<List<String>> units) {
    /* Return a map of `squares` and their associated units (row, col, box)
        */
    Map<String, List<List<String>>> squareUnitMap = {};

    // For every square...
    for (var si in squares) {
      var curSquare = si;

      // Maintain a list of the current square's units
      List<List<String>> curSquareUnits = [];

      // Look through the units, and see if the current square is in it,
      // and if so, add it to the list of of the square's units.
      for (var ui in units) {
        var curUnit = ui;

        if (curUnit.contains(curSquare)) {
          curSquareUnits.add(curUnit);
        }
      }

      // Save the current square and its units to the map
      squareUnitMap[curSquare] = curSquareUnits;
    }

    return squareUnitMap;
  }

  Map<String, List<String>> getSquarePeersMap(
      List<String> squares, Map<String, List<List<String>>> unitsMap) {
    /* Return a map of `squares` and their associated peers, i.e., a set of
        other squares in the square's unit.
        */
    Map<String, List<String>> squarePeersMap = {};

    // For every square...
    for (var si in squares) {
      var curSquare = si;
      var curSquareUnits = unitsMap[curSquare];

      // Maintain list of the current square's peers
      List<String> curSquarePeers = [];

      // Look through the current square's units map...
      for (var sui in curSquareUnits!) {
        var curUnit = sui;

        for (var ui in curUnit) {
          var curUnitSquare = ui;

          if (!curSquarePeers.contains(curUnitSquare) &&
              curUnitSquare != curSquare) {
            curSquarePeers.add(curUnitSquare);
          }
        }
      }

      // Save the current square an its associated peers to the map
      squarePeersMap[curSquare] = curSquarePeers;
    }

    return squarePeersMap;
  }

  List<String> cross(String a, String b) {
    /* Cross product of all elements in `a` and `b`, e.g.,
        sudoku._cross("abc", "123") ->
        ["a1", "a2", "a3", "b1", "b2", "b3", "c1", "c2", "c3"]
        */
    List<String> result = [];
    List aList = a.split('');
    List bList = b.split('');
    for (var ai in aList) {
      for (var bi in bList) {
        result.add('$ai$bi');
      }
    }
    return result;
  }

  // Solve
  // -------------------------------------------------------------------------
  String solve(String board, {bool? reverse}) {
    /* Solve a sudoku puzzle given a sudoku `board`, i.e., an 81-character
        string of sudoku.DIGITS, 1-9, and spaces identified by '.', representing the
        squares. There must be a minimum of 17 givens. If the given board has no
        solutions, return false.

        Optionally set `reverse` to solve "backwards", i.e., rotate through the
        possibilities in reverse. Useful for checking if there is more than one
        solution.
        */

    // Assure a valid board
    var report = validateBoard(board);
    if (report != true) {
      throw report;
    }
    // Check number of givens is at least MIN_GIVENS
    var nrGivens = 0;
    List boardList = board.split('');
    for (var i = 0; i < boardList.length; i++) {
      if (board[i] != blankChar && _inStr(board[i], digits)) {
        ++nrGivens;
      }
    }
    if (nrGivens < minGivens) {
      throw "Too few givens. Minimum givens is $minGivens";
    }

    // Default reverse to false
    var candidates = getCandidatesMap(board);
    var result = _search(candidates, reverse: reverse);

    if (result.isNotEmpty) {
      var solution = "";
      result.forEach((key, value) {
        solution += value;
      });
      return solution;
    }
    return '';
  }

  Map<String, String> _search(Map<String, String> candidates, {bool? reverse}) {
    /* Given a map of squares -> candiates, using depth-first search,
        recursively try all possible values until a solution is found, or false
        if no solution exists.
        */

    // Return if error in previous iteration
    if (candidates.isEmpty) {
      return {};
    }

    // Default reverse to false
    // reverse = reverse || false;

    // If only one candidate for every square, we've a solved puzzle!
    // Return the candidates map.
    var maxNrCandidates = 0;
    // var maxCandidatesSquare;
    for (var i = 0; i < squares.length; i++) {
      var square = squares[i];

      var nrCandidates = candidates[square]?.length ?? 0;

      if (nrCandidates > maxNrCandidates) {
        maxNrCandidates = nrCandidates;
        // maxCandidatesSquare = square;
      }
    }
    if (maxNrCandidates == 1) {
      return candidates;
    }

    // Choose the blank square with the fewest possibilities > 1
    var minNrCandidates = 10;
    String? minCandidatesSquare;
    for (var i = 0; i < squares.length; i++) {
      var square = (squares)[i];

      var nrCandidates = candidates[square]?.length ?? 0;

      if (nrCandidates < minNrCandidates && nrCandidates > 1) {
        minNrCandidates = nrCandidates;
        minCandidatesSquare = square;
      }
    }

    // Recursively search through each of the candidates of the square
    // starting with the one with fewest candidates.

    // Rotate through the candidates forwards
    var minCandidates = candidates[minCandidatesSquare];
    if (!(reverse ?? false)) {
      List<String> minCandidateslist = '$minCandidates'.split('');
      for (var vi in minCandidateslist) {
        var val = vi;

        // TODO: Implement a non-rediculous deep copy function
        Map<String, String> candidatesCopy = {};
        candidates.forEach((key, value) {
          candidatesCopy[key] = value;
        });
        var candidatesNext =
            _search(_assign(candidatesCopy, minCandidatesSquare ?? '', val));

        if (candidatesNext.isNotEmpty) {
          return candidatesNext;
        }
      }

      // Rotate through the candidates backwards
    } else {
      for (var vi = (minCandidates?.length ?? 0) - 1; vi >= 0; --vi) {
        var val = minCandidates![vi];

        // TODO: Implement a non-rediculous deep copy function
        var candidatesCopy = jsonDecode(jsonEncode(candidates));
        var candidatesNext = _search(
            _assign(candidatesCopy, minCandidatesSquare ?? '', val),
            reverse: reverse);

        if (candidatesNext.isNotEmpty) {
          return candidatesNext;
        }
      }
    }

    // If we get through all combinations of the square with the fewest
    // candidates without finding an answer, there isn't one. Return false.
    return {};
  }

  List<String> _stripDups(seq) {
    /* Strip duplicate values from `seq`
        */
    List<String> seqSet = [];
    Map<String, bool> dupMap = {};
    for (var i in seq) {
      // var e = seq[i];
      var e = i;
      if (!dupMap.containsKey(e)) {
        seqSet.add(e);
        dupMap[e] = true;
      }
    }
    return seqSet;
  }

  List<String> _shuffle(List<String> seq) {
    /* Return a shuffled version of `seq`
        */

    // Create an array of the same size as `seq` filled with false
    List<String> shuffled = [];
    for (var i = 0; i < seq.length; ++i) {
      shuffled.add('');
    }

    for (var i = 0; i < seq.length; i++) {
      var ti = _randRange(seq.length);

      while (shuffled[ti].isNotEmpty) {
        ti = (ti + 1) > (seq.length - 1) ? 0 : (ti + 1);
      }

      shuffled[ti] = seq[i];
    }

    return shuffled;
  }

  List<int> _shuffleInt(List<int> seq) {
    /* Return a shuffled version of `seq`
        */

    // Create an array of the same size as `seq` filled with false
    List<int> shuffled = [];
    for (var i = 0; i < seq.length; ++i) {
      shuffled.add(0);
    }

    for (var i = 0; i < seq.length; i++) {
      var ti = _randRange(seq.length);

      while (shuffled[ti] != 0) {
        ti = (ti + 1) > (seq.length - 1) ? 0 : (ti + 1);
      }

      shuffled[ti] = seq[i];
    }

    return shuffled;
  }

  int _randRange(int? max, {int? min}) {
    /* Get a random integer in the range of `min` to `max` (non inclusive).
        If `min` not defined, default to 0. If `max` not defined, throw an
        error.
        */
    return (Random().nextInt(((max ?? 0) - (min ?? 0)))).truncate() +
        (min ?? 0);
  }

  int forceRange(int? nr, int? max, int? min) {
    /* Force `nr` to be within the range from `min` to, but not including,
        `max`. `min` is optional, and will default to 0. If `nr` is undefined,
        treat it as zero.
        */
    if ((nr ?? 0) < (min ?? 0)) {
      return (min ?? 0);
    }
    if ((nr ?? 0) > (max ?? 0)) {
      return max ?? 0;
    }
    return nr ?? 0;
  }


  List<List<String>> getCandidates(String board){
    /* Return all possible candidatees for each square as a grid of
        candidates, returnning `false` if a contradiction is encountered.

        Really just a wrapper for sudoku._get_candidates_map for programmer
        consumption.
        */

    // Assure a valid board
    var report = validateBoard(board);
    if(report != true){
      throw report;
    }

    // Get a candidates map
    var candidatesMap = getCandidatesMap(board);

    // If there's an error, return false
    if(candidatesMap.isEmpty){
      return [];
    }

    // Transform candidates map into grid
    List<List<String>> rows = [];
    List<String> curRow = [];
    var i = 0;
    candidatesMap.forEach((key, square) {
      var candidates = square;
      curRow.add(candidates);
      if(i % 9 == 8){
        rows.add(curRow);
        curRow = [];
      }
      ++i;
    });
    return rows;
  }

  Map<String, String> getCandidatesMap(String board) {
    /* Get all possible candidates for each square as a map in the form
        {square: sudoku.DIGITS} using recursive constraint propagation. Return `false`
        if a contradiction is encountered
        */

    // Assure a valid board
    var report = validateBoard(board);
    if (report != true) {
      throw report;
    }

    Map<String, String> candidateMap = {};
    Map squaresValuesMap = _getSquareValsMap(board);

    // Start by assigning every digit as a candidate to every square
    for (var si in squares) {
      candidateMap[si] = digits;
    }

    // For each non-blank square, assign its value in the candidate map and
    // propigate.
    squaresValuesMap.forEach((key, value) {
      var square = key;
      var val = value;
      if (_inStr(val, digits)) {
        var newCandidates = _assign(candidateMap, square, val);

        // Fail if we can't assign val to square
        if (newCandidates.isEmpty) {
          return;
        }
      }
    });
    // for(var square in squares_values_map){
    //   var val = squares_values_map[square];
    //
    //   if(inStr(val,digits)){
    //     var new_candidates = _assign(candidate_map, square, val);
    //
    //     // Fail if we can't assign val to square
    //     if(!new_candidates){
    //       return false;
    //     }
    //   }
    // }

    return candidateMap;
  }

  bool validateBoard(String board) {
    /* Return if the given `board` is valid or not. If it's valid, return
        true. If it's not, return a string of the reason why it's not.
        */

    // Check for empty board
    if (board.isEmpty) {
      debugPrint('Empty board');
      return false;
    }

    // Invalid board length
    if (board.length != nrSquares) {
      debugPrint(
          'Invalid board size. Board must be exactly $nrSquares squares.');
      return false;
    }

    // Check for invalid characters
    for (var i = 0; i < board.length; i++) {
      if (!_inStr(board[i], digits) && board[i] != blankChar) {
        debugPrint(
            '${"Invalid board character encountered at index $i"}: ${board[i]}');
        return false;
      }
    }
    // Otherwise, we're good. Return true.
    return true;
  }

  bool _inStr(String v, String seq) {
    /* Return if a value `v` is in sequence `seq`.
        */
    return seq.contains(v);
  }

  Map<String, String> _assign(
      Map<String, String> candidates, String square, String val) {
    /* Elimina_assignte all values, *except* for `val`, from `candidates` at
        `square` (candidates[square]), and propagate. Return the candidates map
        when finished. If a contradiciton is found, return false.

        WARNING: This will modify the contents of `candidates` directly.
        */
    // Grab a list of canidates without 'val'
    var otherVals = candidates[square]?.replaceAll(val, "");
    // Loop through all other values and eliminate them from the candidates
    // at the current square, and propigate. If at any point we get a
    // contradiction, return false.
    List<String> otherValslist = otherVals?.split('') ?? [];
    for (var ovi in otherValslist) {
      var otherVal = ovi;

      var candidatesNext = _eliminate(candidates, square, otherVal);
      if (candidatesNext.isEmpty) {
        //console.log("Contradiction found by _eliminate.");
        return {};
      }
    }
    return candidates;
  }

  Map<String, String> _getSquareValsMap(String board) {
    /* Return a map of squares -> values
        */
    Map<String, String> squaresValsMap = {};

    // Make sure `board` is a string of length 81
    if (board.length != squares.length) {
      throw "Board/squares length mismatch.";
    } else {
      for (var i = 0; i < squares.length; i++) {
        squaresValsMap[squares[i]] = board[i];
      }
      // for(var i in squares){
      //   squares_vals_map[i] = board[i];
      // }
    }

    return squaresValsMap;
  }

  Map _eliminate(Map<String, String> candidates, square, val) {
    /* Eliminate `val` from `candidates` at `square`, (candidates[square]),
        and propagate when values or places <= 2. Return updated candidates,
        unless a contradiction is detected, in which case, return false.

        WARNING: This will modify the contents of `candidates` directly.
        */
    // var candidate = candidates[square];
    // LoggerUtil.d('square:$square val:$val candidate:$candidate');
    // If `val` has already been eliminated from candidates[square], return
    // with candidates.
    if (!_inStr(val, candidates[square] ?? '')) {
      return candidates;
    }

    // Remove `val` from candidates[square]
    candidates[square] = candidates[square]?.replaceAll(val, '') ?? '';

    // candidate = candidates[square];
    // LoggerUtil.d('tag1 square:$square val:$val candidate:$candidate');

    // LoggerUtil.d('candidates square:$square $candidates[square] ');
    // If the square has only candidate left, eliminate that value from its
    // peers
    var nrCandidates = candidates[square]?.length;
    if (nrCandidates == 1) {
      var targetVal = candidates[square];

      for (var pi in squarePeersMap[square]) {
        // var peer = SQUARE_PEERS_MAP[square][pi];
        var peer = pi;

        var candidatesNew = _eliminate(candidates, peer, targetVal);

        if (candidatesNew.isEmpty) {
          return {};
        }
      }

      // Otherwise, if the square has no candidates, we have a contradiction.
      // Return false.
    }
    if (nrCandidates == 0) {
      return {};
    }

    // If a unit is reduced to only one place for a value, then assign it
    for (var ui in squareUnitsMap[square]!) {
      // var unit = SQUARE_UNITS_MAP[square][ui];
      var unit = ui;
      var valPlaces = [];
      for (var si in unit) {
        // var unit_square = unit[si];
        var unitSquare = si;
        if (_inStr(val, candidates[unitSquare] ?? '')) {
          valPlaces.add(unitSquare);
        }
      }

      // If there's no place for this value, we have a contradition!
      // return false
      if (valPlaces.isEmpty) {
        return {};

        // Otherwise the value can only be in one place. Assign it there.
      } else if (valPlaces.length == 1) {
        var candidatesNew = _assign(candidates, valPlaces[0], val);

        if (candidatesNew.isEmpty) {
          return {};
        }
      }
    }

    return candidates;
  }


  // Conversions
  // -------------------------------------------------------------------------
  List<List<String>> boardStrToGrid(String boardStr){
    /* Convert a board string to a two-dimensional array
        */
    List<List<String>> rows = [];
    List<String> curRow = [];
    List<String> boardStrList = boardStr.split('');
    for(var i = 0 ; i < boardStrList.length ; i++){
      curRow.add(boardStrList[i]);
      if(i % 9 == 8){
        rows.add(curRow);
        curRow = [];
      }
    }
    return rows;
  }

  String boardGridToStr(List<List<String>> boardGrid){
    if(boardGrid.length != 9){
      LoggerUtil.e('boardGridToStr boardGrid length:${boardGrid.length} is error ');
      return '';
    }
    /* Convert a board grid to a string
        */
    String boardStr = "";
    for(var r = 0; r < 9; ++r){
      for(var c = 0; c < 9; ++c){
        boardStr += boardGrid[r][c];
      }
    }
    return boardStr;
  }


}
