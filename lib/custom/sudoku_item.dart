import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/sudoku_controller.dart';
import '../models/sudoku_model.dart';

class SudokuItem extends StatelessWidget {
  SudokuModel? sudoku;
  double? rowW;
  SudokuController? controller;

  SudokuItem(
      {super.key,
      required this.sudoku,
      required this.rowW,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getColor(),
        border: Border.all(
          color: Colors.black45, //边框颜色
          width: 2, //宽度
        ),
      ),
      width: (rowW ?? 0),
      height: (rowW ?? 0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '${sudoku?.value ?? 0}',
              style: TextStyle(fontSize: 10.sp),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(1.w, 1.w, 1.w, 1.w),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             '1',
          //             style: TextStyle(fontSize: 6.sp),
          //           ),
          //           Text(
          //             '2',
          //             style: TextStyle(fontSize: 6.sp),
          //           )
          //         ],
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             '3',
          //             style: TextStyle(fontSize: 6.sp),
          //           ),
          //           Text(
          //             '4',
          //             style: TextStyle(fontSize: 6.sp),
          //           )
          //         ],
          //       )
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(1.w, 1.w, 1.w, 1.w),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             '1',
          //             style: TextStyle(fontSize: 4.sp),
          //           ),
          //           Text(
          //             '2',
          //             style: TextStyle(fontSize: 4.sp),
          //           )
          //         ],
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             '3',
          //             style: TextStyle(fontSize: 4.sp),
          //           ),
          //           Text(
          //             '4',
          //             style: TextStyle(fontSize: 4.sp),
          //           )
          //         ],
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             '5',
          //             style: TextStyle(fontSize: 4.sp),
          //           ),
          //           Text(
          //             '6',
          //             style: TextStyle(fontSize: 4.sp),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(1.w, 1.w, 1.w, 1.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1',
                      style: TextStyle(fontSize: 4.sp),
                    ),
                    Text(
                      '2',
                      style: TextStyle(fontSize: 4.sp),
                    ),
                    Text(
                      '3',
                      style: TextStyle(fontSize: 4.sp),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '4',
                      style: TextStyle(fontSize: 4.sp),
                    ),
                    Text(
                      '5',
                      style: TextStyle(fontSize: 4.sp),
                    ),
                    Text(
                      '6',
                      style: TextStyle(fontSize: 4.sp),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '7',
                      style: TextStyle(fontSize: 4.sp),
                    ),
                    Text(
                      '8',
                      style: TextStyle(fontSize: 4.sp),
                    ),
                    Text(
                      '9',
                      style: TextStyle(fontSize: 4.sp),
                    )
                  ],
                ),
              ],
            ),
          )
          // Align(
          //   alignment: Alignment.center,
          //   child: Column(
          //     children: [
          //       Text('px:${sudoku?.pX}'),
          //       Text('py:${sudoku?.pY}'),
          //       Text('gX:${sudoku?.gX}'),
          //       Text('gY:${sudoku?.gY}')
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Color getColor() {
    if (controller?.pX == sudoku?.pX || controller?.pY == sudoku?.pY) {
      return Colors.white60;
    } else if (controller?.gX == sudoku?.gX && controller?.gY == sudoku?.gY) {
      return Colors.white70;
    } else {
      return Colors.white;
    }
  }
}
