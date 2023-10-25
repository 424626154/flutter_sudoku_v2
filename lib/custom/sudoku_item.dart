import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sudoku_v2/apps/app_theme.dart';

import '../controller/sudoku_controller.dart';
import '../models/sudoku_model.dart';
import '../sudoku/sudoku_generator.dart';

class SudokuItem extends StatelessWidget {
  final SudokuModel? sudoku;
  final double? rowW;
  final SudokuController? controller;

  const SudokuItem(
      {super.key,
      required this.sudoku,
      required this.rowW,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: getColor(),
          border: Border.all(
            color: AppTheme.cE9E9EC, //边框颜色
            width: 1.w, //宽度
          ),
        ),
        width: (rowW ?? 0),
        height: (rowW ?? 0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: (sudoku?.value ?? '') == '.'
                  ? Container()
                  : Text(
                sudoku?.value ?? '',
                style: TextStyle(fontSize: 10.sp),
              ),
            ),
            _buildSelect(),
            // (sudoku?.value == SudokuGenerator.blankChar)&&(sudoku?.solve ?? '').isNotEmpty
            //     ? Align(
            //   alignment: Alignment.center,
            //   child: (sudoku?.solve ?? '') == '.'
            //       ? Container()
            //       : Text(
            //     sudoku?.solve ?? '',
            //     style: TextStyle(fontSize: 10.sp, color: Colors.red),
            //   ),
            // )
            //     : Container(),
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
            // Padding(
            //   padding: EdgeInsets.fromLTRB(1.w, 1.w, 1.w, 1.w),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           sudoku?.candidatesMap?.containsKey('1') ?? false
            //               ? Text(
            //                   '1',
            //                   style: TextStyle(fontSize: 4.sp),
            //                 )
            //               : Container(),
            //           sudoku?.candidatesMap?.containsKey('2') ?? false
            //               ? Text(
            //                   '2',
            //                   style: TextStyle(fontSize: 4.sp),
            //                 )
            //               : Container(),
            //           sudoku?.candidatesMap?.containsKey('3') ?? false
            //               ? Text(
            //                   '3',
            //                   style: TextStyle(fontSize: 4.sp),
            //                 )
            //               : Container()
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           sudoku?.candidatesMap?.containsKey('4') ?? false
            //               ? Text(
            //                   '4',
            //                   style: TextStyle(fontSize: 4.sp),
            //                 )
            //               : Container(),
            //           sudoku?.candidatesMap?.containsKey('5') ?? false
            //               ? Text(
            //                   '5',
            //                   style: TextStyle(fontSize: 4.sp),
            //                 )
            //               : Container(),
            //           sudoku?.candidatesMap?.containsKey('6') ?? false
            //               ? Text(
            //                   '6',
            //                   style: TextStyle(fontSize: 4.sp),
            //                 )
            //               : Container()
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           sudoku?.candidatesMap?.containsKey('7') ?? false
            //               ? Text(
            //                   '7',
            //                   style: TextStyle(fontSize: 4.sp),
            //                 )
            //               : Container(),
            //           sudoku?.candidatesMap?.containsKey('8') ?? false
            //               ? Text(
            //                   '8',
            //                   style: TextStyle(fontSize: 4.sp),
            //                 )
            //               : Container(),
            //           sudoku?.candidatesMap?.containsKey('9') ?? false
            //               ? Text(
            //                   '9',
            //                   style: TextStyle(fontSize: 4.sp),
            //                 )
            //               : Container()
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            _buildDrafts(),
            // Align(
            //   alignment: Alignment.center,
            //   child: Opacity(
            //     opacity: 0.4,
            //     child: Column(
            //       children: [
            //         Text('px:${sudoku?.pX}'),
            //         Text('py:${sudoku?.pY}'),
            //         Text('gX:${sudoku?.gX}'),
            //         Text('gY:${sudoku?.gY}')
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Color getColor() {
    if (controller?.pX == sudoku?.pX && controller?.pY == sudoku?.pY) {
      return Color(0x66AFC0F2);
    } else if (controller?.pX == sudoku?.pX || controller?.pY == sudoku?.pY) {
      return Color(0x66AFC0F2);
    } else if (controller?.gX == sudoku?.gX && controller?.gY == sudoku?.gY) {
      return Color(0x66AFC0F2);
    } else {
      return Colors.white;
    }
  }

  Widget _buildSelect() {
    return (sudoku?.select ?? '').isNotEmpty &&
            (sudoku?.select ?? '') != SudokuGenerator.blankChar
        ? Align(
            alignment: Alignment.center,
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              margin: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: sudoku?.select == sudoku?.solve
                    ? Color(0x66AFC0F0)
                    : Color(0x66FF4500),
                borderRadius: BorderRadius.all(Radius.circular(2.r)),
              ),
              child: Center(
                child: Text(
                  sudoku?.select ?? '',
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: sudoku?.select == sudoku?.solve
                          ? AppTheme.primaryColor
                          : Color(0xFFFF4500)),
                ),
              ),
            ),
          )
        : Container();
  }

  ///绘制草稿笔记
  Widget _buildDrafts() {
    bool isSelectEmpty = (sudoku?.select == SudokuGenerator.blankChar);
    bool isDraftNotEmpty = sudoku?.draftMap.isNotEmpty ?? false;
    return isDraftNotEmpty && isSelectEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDraft('1'),
                  _buildDraft('2'),
                  _buildDraft('3'),
                ],
              )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDraft('4'),
                  _buildDraft('5'),
                  _buildDraft('6'),
                ],
              )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDraft('7'),
                  _buildDraft('8'),
                  _buildDraft('9'),
                ],
              )),
            ],
          )
        : Container();
  }

  Widget _buildDraft(String label) {
    return Expanded(
        child: Container(
      color: Colors.yellow,
      child: sudoku?.draftMap.containsKey(label) ?? false
          ? Center(
              child: Text(
                label,
                style: TextStyle(fontSize: 4.sp, color: Colors.lightBlue),
              ),
            )
          : Container(),
    ));
  }
}
