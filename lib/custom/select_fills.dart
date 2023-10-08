import 'package:flutter/material.dart';
import 'package:flutter_sudoku_v2/custom/select_fill_item.dart';

class SelectFills extends StatelessWidget {
  List<String> fills;
  double itemSize;
  OnSelectFillItemCallback? onSelectFillItemCallback;
  SelectFills({super.key, required this.fills,required this.itemSize,this.onSelectFillItemCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: fills.map((e){
        return SelectFillItem(
          itemSize:itemSize,
          value: e,
          onSelectFillItemCallback: onSelectFillItemCallback,
        );
      }).toList(),
    );
  }
}
