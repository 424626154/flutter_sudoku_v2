import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnSelectFillItemCallback = Function(String value);

class SelectFillItem extends StatelessWidget {
  double itemSize;
  String value;
  OnSelectFillItemCallback? onSelectFillItemCallback;

  SelectFillItem(
      {super.key, required this.itemSize,required this.value, this.onSelectFillItemCallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: itemSize,
        height: itemSize,
        color: Colors.blueGrey,
        child: Center(
          child: Text(value,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
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
