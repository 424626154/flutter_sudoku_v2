import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sudoku_v2/apps/app_theme.dart';

typedef OnSelectFillItemCallback = Function(String value);

class SelectFillItem extends StatelessWidget {
  final double itemSize;
  final String value;
  final OnSelectFillItemCallback? onSelectFillItemCallback;

  const SelectFillItem(
      {super.key,
      required this.itemSize,
      required this.value,
      this.onSelectFillItemCallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
        width: itemSize * 1.4,
        height: itemSize,
        decoration: BoxDecoration(
          color: AppTheme.cE9E9EC,
          borderRadius: BorderRadius.all(Radius.circular(6.r)),
          border: Border.all(
            color: AppTheme.cCCD0D9, //边框颜色
            width: 0.5.w, //宽度
          )
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor),
          ),
        ),
      ),
      onTap: () {
        if (onSelectFillItemCallback != null) {
          onSelectFillItemCallback!(value);
        }
      },
    );
  }
}
