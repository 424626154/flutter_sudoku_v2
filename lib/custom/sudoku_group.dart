

import 'package:flutter/material.dart';
import 'package:flutter_sudoku_v2/custom/sudoku_item.dart';

import '../controller/sudoku_controller.dart';
import '../models/sudoku_group_model.dart';

class SudokuGroup extends StatelessWidget {
  final SudukuGroupMode groupData;
  final double? rowW;
  final SudokuController? controller;
  const SudokuGroup({super.key,required this.groupData,required this.rowW,required this.controller});
  @override
  Widget build(BuildContext context) {
    var rowsDaota = groupData.gropup;
    return SizedBox(
      width: (rowW ?? 0)*3,
      height: (rowW ?? 0)*3,
      child: Column(
        children: List.generate(rowsDaota.length, (index){
          var rows = (rowsDaota)[index];
          return SizedBox(
            width: (rowW ?? 0)*3,
            height: (rowW ?? 0),
            child: Row(
              children: List.generate(rows.length, (index){
                var sudoku = rows[index];
                return SudokuItem(sudoku: sudoku, rowW: (rowW ?? 0),controller: controller,);
              }),
            ),
          );
        }).toList(),
      ),
    );
  }

}