// import 'dart:convert';
// import 'dart:math';
//
// // https://github.com/robatron/sudoku.js/blob/master/sudoku.js
// class SudokuGeneratorModel {
//   String? digits;
//   String? blank_char;
//   String? blank_board;
//
//   var MIN_GIVENS = 17;            // Minimum number of givens
//   var NR_SQUARES = 81;            // Number of squares
//
//
//   // Define difficulties by how many squares are given to the player in a new
//   // puzzle.
//   Map<String,int> DIFFICULTY = {
//     "easy":         62,
//     "medium":       53,
//     "hard":         44,
//     "very-hard":    35,
//     "insane":       26,
//     "inhuman":      17,
//   };
//
//   var SQUARE_PEERS_MAP = null;    // Squares -> peers map
//   var SQUARE_UNITS_MAP = null;
//   late List squares ;
//
//   String cross(String rows, String cols){
//     return '';
//   }
//
//
//   String get_all_units(String rows, String cols){
//     return '';
//   }
//
//   String get_square_units_map(String squares, String units){
//     return '';
//   }
//
//   String get_square_peers_map(String squares, String square_units_map){
//     return '';
//   }
//
//
//   // Generate
//   // -------------------------------------------------------------------------
//   generate(difficulty, {bool? unique}){
//     /* Generate a new Sudoku puzzle of a particular `difficulty`, e.g.,
//
//             // Generate an "easy" sudoku puzzle
//             sudoku.generate("easy");
//
//
//         Difficulties are as follows, and represent the number of given squares:
//
//                 "easy":         61
//                 "medium":       52
//                 "hard":         43
//                 "very-hard":    34
//                 "insane":       25
//                 "inhuman":      17
//
//
//         You may also enter a custom number of squares to be given, e.g.,
//
//             // Generate a new Sudoku puzzle with 60 given squares
//             sudoku.generate(60)
//
//
//         `difficulty` must be a number between 17 and 81 inclusive. If it's
//         outside of that range, `difficulty` will be set to the closest bound,
//         e.g., 0 -> 17, and 100 -> 81.
//
//
//         By default, the puzzles are unique, uless you set `unique` to false.
//         (Note: Puzzle uniqueness is not yet implemented, so puzzles are *not*
//         guaranteed to have unique solutions)
//
//         TODO: Implement puzzle uniqueness
//         */
//
//     // If `difficulty` is a string or undefined, convert it to a number or
//     // default it to "easy" if undefined.
//     if(difficulty  is String){
//       difficulty = DIFFICULTY[difficulty];
//     }
//
//     // Force difficulty between 17 and 81 inclusive
//     difficulty = force_range(difficulty, NR_SQUARES + 1,
//         MIN_GIVENS);
//
//     // Default unique to true
//     // unique = unique || true;
//
//     // Get a set of squares and all possible candidates for each square
//     var blank_board = "";
//     for(var i = 0; i < NR_SQUARES; ++i){
//       blank_board += '.';
//     }
//     var candidates = get_candidates_map(blank_board);
//
//     // For each item in a shuffled list of squares
//     var shuffled_squares = shuffle(squares);
//     for(var si in shuffled_squares){
//       var square = shuffled_squares[si];
//
//       // If an assignment of a random chioce causes a contradictoin, give
//       // up and try again
//       var rand_candidate_idx =
//       _rand_range(candidates[square].length);
//       var rand_candidate = candidates[square][rand_candidate_idx];
//       if(!_assign(candidates, square, rand_candidate)){
//         break;
//       }
//
//       // Make a list of all single candidates
//       var single_candidates = [];
//       for(var si in (squares ?? [])){
//         var square = (squares ?? [])[si];
//
//         if(candidates[square].length == 1){
//           single_candidates.add(candidates[square]);
//         }
//       }
//
//       // If we have at least difficulty, and the unique candidate count is
//       // at least 8, return the puzzle!
//       if(single_candidates.length >= difficulty &&
//           _strip_dups(single_candidates).length >= 8){
//         var board = "";
//         var givens_idxs = [];
//         for(var i in squares){
//           var square = squares[i];
//           if(candidates[square].length == 1){
//             board += candidates[square];
//             givens_idxs.add(i);
//           } else {
//             board += blank_char ?? '';
//           }
//         }
//
//         // If we have more than `difficulty` givens, remove some random
//         // givens until we're down to exactly `difficulty`
//         var nr_givens = givens_idxs.length;
//         if(nr_givens > difficulty){
//           givens_idxs = _shuffle(givens_idxs);
//           for(var i = 0; i < nr_givens - difficulty; ++i){
//             var target = int.parse(givens_idxs[i]);
//             board = board.substring(0, target) + (blank_char ?? '') +
//                 board.substring(target + 1);
//           }
//         }
//
//         // Double check board is solvable
//         // TODO: Make a standalone board checker. Solve is expensive.
//         if(solve(board)){
//           return board;
//         }
//       }
//     }
//
//     // Give up and try a new puzzle
//     return generate(difficulty);
//   }
//
//   // Solve
//   // -------------------------------------------------------------------------
//   solve(board,{bool? reverse}){
//     /* Solve a sudoku puzzle given a sudoku `board`, i.e., an 81-character
//         string of sudoku.DIGITS, 1-9, and spaces identified by '.', representing the
//         squares. There must be a minimum of 17 givens. If the given board has no
//         solutions, return false.
//
//         Optionally set `reverse` to solve "backwards", i.e., rotate through the
//         possibilities in reverse. Useful for checking if there is more than one
//         solution.
//         */
//
//     // Assure a valid board
//     var report = validate_board(board);
//     if(report != true){
//       throw report;
//     }
//
//     // Check number of givens is at least MIN_GIVENS
//     var nr_givens = 0;
//     for(var i in board){
//       if(board[i] != blank_board  && _in(board[i], digits)){
//     ++nr_givens;
//     }
//     }
//     if(nr_givens < MIN_GIVENS){
//     throw "Too few givens. Minimum givens is $MIN_GIVENS";
//     }
//
//     // Default reverse to false
//     var candidates = _get_candidates_map(board);
//     var result = _search(candidates, reverse:reverse);
//
//     if(result){
//     var solution = "";
//     for(var square in result){
//     solution += result[square];
//     }
//     return solution;
//     }
//     return false;
//   }
//
//
//   _search(candidates, {bool? reverse}){
//     /* Given a map of squares -> candiates, using depth-first search,
//         recursively try all possible values until a solution is found, or false
//         if no solution exists.
//         */
//
//     // Return if error in previous iteration
//     if(!candidates){
//       return false;
//     }
//
//     // Default reverse to false
//     // reverse = reverse || false;
//
//     // If only one candidate for every square, we've a solved puzzle!
//     // Return the candidates map.
//     var max_nr_candidates = 0;
//     var max_candidates_square = null;
//     for(var si in squares){
//       var square = squares[si];
//
//       var nr_candidates = candidates[square].length;
//
//       if(nr_candidates > max_nr_candidates){
//         max_nr_candidates = nr_candidates;
//         max_candidates_square = square;
//       }
//     }
//     if(max_nr_candidates == 1){
//       return candidates;
//     }
//
//     // Choose the blank square with the fewest possibilities > 1
//     var min_nr_candidates = 10;
//     var min_candidates_square = null;
//     for(var si in squares){
//       var square = (squares ?? [])[si];
//
//       var nr_candidates = candidates[square].length;
//
//       if(nr_candidates < min_nr_candidates && nr_candidates > 1){
//         min_nr_candidates = nr_candidates;
//         min_candidates_square = square;
//       }
//     }
//
//     // Recursively search through each of the candidates of the square
//     // starting with the one with fewest candidates.
//
//     // Rotate through the candidates forwards
//     var min_candidates = candidates[min_candidates_square];
//     if(!(reverse ?? false)){
//       for(var vi in min_candidates){
//         var val = min_candidates[vi];
//
//         // TODO: Implement a non-rediculous deep copy function
//         var candidates_copy = jsonDecode(jsonEncode(candidates));
//         var candidates_next = _search(
//             _assign(candidates_copy, min_candidates_square, val)
//         );
//
//         if(candidates_next){
//           return candidates_next;
//         }
//       }
//
//       // Rotate through the candidates backwards
//     } else {
//       for(var vi = min_candidates.length - 1; vi >= 0; --vi){
//         var val = min_candidates[vi];
//
//         // TODO: Implement a non-rediculous deep copy function
//         var candidates_copy = jsonDecode(jsonEncode(candidates));
//         var candidates_next = _search(
//             _assign(candidates_copy, min_candidates_square, val),
//             reverse:reverse
//         );
//
//         if(candidates_next){
//           return candidates_next;
//         }
//       }
//     }
//
//     // If we get through all combinations of the square with the fewest
//     // candidates without finding an answer, there isn't one. Return false.
//     return false;
//   }
//
//   _get_candidates_map(board){
//     /* Get all possible candidates for each square as a map in the form
//         {square: sudoku.DIGITS} using recursive constraint propagation. Return `false`
//         if a contradiction is encountered
//         */
//
//     // Assure a valid board
//     var report = validate_board(board);
//     if(report != true){
//       throw report;
//     }
//
//     var candidate_map = {};
//     var squares_values_map = _get_square_vals_map(board);
//
//     // Start by assigning every digit as a candidate to every square
//     for(var si in squares){
//       candidate_map[squares[si]] = digits;
//     }
//
//     // For each non-blank square, assign its value in the candidate map and
//     // propigate.
//     for(var square in squares_values_map){
//       var val = squares_values_map[square];
//
//       if(_in(val, digits)){
//         var new_candidates = _assign(candidate_map, square, val);
//
//         // Fail if we can't assign val to square
//         if(!new_candidates){
//           return false;
//         }
//       }
//     }
//
//     return candidate_map;
//   }
//
//   _shuffle(seq){
//     /* Return a shuffled version of `seq`
//         */
//
//     // Create an array of the same size as `seq` filled with false
//     var shuffled = [];
//     for(var i = 0; i < seq.length; ++i){
//       shuffled.add(false);
//     }
//
//     for(var i in seq){
//       var ti = _rand_range(seq.length);
//
//       while(shuffled[ti]){
//         ti = (ti + 1) > (seq.length - 1) ? 0 : (ti + 1);
//       }
//
//       shuffled[ti] = seq[i];
//     }
//
//     return shuffled;
//   }
//
//   get_candidates_map(board){
//     /* Get all possible candidates for each square as a map in the form
//         {square: sudoku.DIGITS} using recursive constraint propagation. Return `false`
//         if a contradiction is encountered
//         */
//
//     // Assure a valid board
//     var report = validate_board(board);
//     if(report != true){
//       throw report;
//     }
//
//     var candidate_map = {};
//     var squares_values_map = _get_square_vals_map(board);
//
//     // Start by assigning every digit as a candidate to every square
//     for(var si in squares){
//       candidate_map[squares[si]] = digits;
//     }
//
//     // For each non-blank square, assign its value in the candidate map and
//     // propigate.
//     for(var square in squares_values_map){
//       var val = squares_values_map[square];
//
//       if(_in(val,digits)){
//         var new_candidates = _assign(candidate_map, square, val);
//
//         // Fail if we can't assign val to square
//         if(!new_candidates){
//           return false;
//         }
//       }
//     }
//
//     return candidate_map;
//   }
//
//   _assign(candidates, square, val){
//     /* Elimina_assignte all values, *except* for `val`, from `candidates` at
//         `square` (candidates[square]), and propagate. Return the candidates map
//         when finished. If a contradiciton is found, return false.
//
//         WARNING: This will modify the contents of `candidates` directly.
//         */
//
//     // Grab a list of canidates without 'val'
//     var other_vals = candidates[square].replace(val, "");
//
//     // Loop through all other values and eliminate them from the candidates
//     // at the current square, and propigate. If at any point we get a
//     // contradiction, return false.
//     for(var ovi in other_vals){
//       var other_val = other_vals[ovi];
//
//       var candidates_next =
//       _eliminate(candidates, square, other_val);
//
//       if(!candidates_next){
//         //console.log("Contradiction found by _eliminate.");
//         return false;
//       }
//     }
//
//     return candidates;
//   }
//
//   _eliminate(candidates, square, val){
//     /* Eliminate `val` from `candidates` at `square`, (candidates[square]),
//         and propagate when values or places <= 2. Return updated candidates,
//         unless a contradiction is detected, in which case, return false.
//
//         WARNING: This will modify the contents of `candidates` directly.
//         */
//
//     // If `val` has already been eliminated from candidates[square], return
//     // with candidates.
//     if(!_in(val, candidates[square])){
//       return candidates;
//     }
//
//     // Remove `val` from candidates[square]
//     candidates[square] = candidates[square].replace(val, '');
//
//     // If the square has only candidate left, eliminate that value from its
//     // peers
//     var nr_candidates = candidates[square].length;
//     if(nr_candidates == 1){
//       var target_val = candidates[square];
//
//       for(var pi in SQUARE_PEERS_MAP[square]){
//         var peer = SQUARE_PEERS_MAP[square][pi];
//
//         var candidates_new =
//         _eliminate(candidates, peer, target_val);
//
//         if(!candidates_new){
//           return false;
//         }
//       }
//
//       // Otherwise, if the square has no candidates, we have a contradiction.
//       // Return false.
//     } if(nr_candidates == 0){
//       return false;
//     }
//
//     // If a unit is reduced to only one place for a value, then assign it
//     for(var ui in SQUARE_UNITS_MAP[square]){
//       var unit = SQUARE_UNITS_MAP[square][ui];
//
//       var val_places = [];
//       for(var si in unit){
//         var unit_square = unit[si];
//         if(_in(val, candidates[unit_square])){
//           val_places.add(unit_square);
//         }
//       }
//
//       // If there's no place for this value, we have a contradition!
//       // return false
//       if(val_places.length == 0){
//         return false;
//
//         // Otherwise the value can only be in one place. Assign it there.
//       } else if(val_places.length == 1){
//         var candidates_new =
//         _assign(candidates, val_places[0], val);
//
//         if(!candidates_new){
//           return false;
//         }
//       }
//     }
//
//     return candidates;
//   }
//
//   _in(v, seq){
//     /* Return if a value `v` is in sequence `seq`.
//         */
//     return seq.indexOf(v) != -1;
//   }
//
//   _strip_dups(seq){
//     /* Strip duplicate values from `seq`
//         */
//     var seq_set = [];
//     var dup_map = {};
//     for(var i in seq){
//       var e = seq[i];
//       if(!dup_map[e]){
//         seq_set.add(e);
//         dup_map[e] = true;
//       }
//     }
//     return seq_set;
//   }
//
//   _get_square_vals_map(board){
//     /* Return a map of squares -> values
//         */
//     var squares_vals_map = {};
//
//     // Make sure `board` is a string of length 81
//     if(board.length != squares.length){
//       throw "Board/squares length mismatch.";
//
//     } else {
//       for(var i in squares){
//         squares_vals_map[squares[i]] = board[i];
//       }
//     }
//
//     return squares_vals_map;
//   }
//
//   validate_board(String board){
//     /* Return if the given `board` is valid or not. If it's valid, return
//         true. If it's not, return a string of the reason why it's not.
//         */
//
//     // Check for empty board
//     if(board.isEmpty){
//       return "Empty board";
//     }
//
//     // Invalid board length
//     if(board.length != NR_SQUARES){
//       return "Invalid board size. Board must be exactly $NR_SQUARES squares.";
//     }
//
//     // Check for invalid characters
//     for(var i  = 0 ; i < board.length ; i++){
//       if(!_in(board[i], digits) && board[i] != blank_char){
//         return "${"Invalid board character encountered at index $i"}: ${board[i]}";
//       }
//     }
//
//     // Otherwise, we're good. Return true.
//     return true;
//   }
//
//
//   int force_range(int? nr, int? max, int? min){
//     /* Force `nr` to be within the range from `min` to, but not including,
//         `max`. `min` is optional, and will default to 0. If `nr` is undefined,
//         treat it as zero.
//         */
//     if((nr ?? 0) < (min ?? 0)){
//       return (min ?? 0);
//     }
//     if((nr ?? 0) > (max ?? 0)){
//       return max ?? 0;
//     }
//     return nr ?? 0;
//   }
//
//   List shuffle(List seq){
//     /* Return a shuffled version of `seq`
//         */
//
//     // Create an array of the same size as `seq` filled with false
//     var shuffled = [];
//     for(var i = 0; i < seq.length; ++i){
//       shuffled.add(false);
//     }
//
//     for(var i in seq){
//       var ti = _rand_range(seq.length);
//
//       while(shuffled[ti]){
//         ti = (ti + 1) > (seq.length - 1) ? 0 : (ti + 1);
//       }
//
//       shuffled[ti] = seq[i];
//     }
//
//     return shuffled;
//   }
//
//
//   int _rand_range(int? max, {int? min}){
//     /* Get a random integer in the range of `min` to `max` (non inclusive).
//         If `min` not defined, default to 0. If `max` not defined, throw an
//         error.
//         */
//     return (Random().nextInt(((max ?? 0) - (min ?? 0)))).truncate() + (min ?? 0);
//   }
//
//
// }