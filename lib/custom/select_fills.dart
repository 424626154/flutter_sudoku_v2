import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sudoku_v2/custom/select_fill_item.dart';

class SelectFills extends StatelessWidget {
  final List<String> fills0 = ['1', '2', '3', '4', '5'];
  final List<String> fills1 = ['6', '7', '8', '9'];
  final double itemSize;
  final OnSelectFillItemCallback? onSelectFillItemCallback;

  SelectFills(
      {super.key, required this.itemSize, this.onSelectFillItemCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: fills0.map((e) {
            return SelectFillItem(
              itemSize: itemSize,
              value: e,
              onSelectFillItemCallback: onSelectFillItemCallback,
            );
          }).toList(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 16.h, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: fills1.map((e) {
              return SelectFillItem(
                itemSize: itemSize,
                value: e,
                onSelectFillItemCallback: onSelectFillItemCallback,
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
