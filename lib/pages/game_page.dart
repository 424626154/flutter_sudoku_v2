import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sudoku_v2/custom/select_fills.dart';
import 'package:flutter_sudoku_v2/sudoku/sudoku_manager.dart';
import 'package:flutter_sudoku_v2/utils/logger_util.dart';
import 'package:get/get.dart';

import '../controller/sudoku_controller.dart';
import '../custom/sudoku_group.dart';
import '../sudoku/difficulty_levels.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<GamePage> {
  SudokuController controller = Get.put(SudokuController());

  double itemW = 0;
  double itemH = 0;
  double pading = 60.h;
  double itemNum = 9;
  double groupItemNum = 3;
  double groupW = 0;
  double groupH = 0;

  @override
  void initState() {
    super.initState();
    controller.initBoard();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double groupNum = itemNum / groupItemNum;
    if (size.width > size.height) {
      itemW = ((size.height - pading) / itemNum);
    } else {
      itemW = ((size.width - pading) / itemNum);
    }
    itemH = itemW;
    groupW = itemW * groupItemNum;
    groupH = groupW;
    var borderW = 2.w;
    return SafeArea(
        child: Scaffold(
      body: GetBuilder<SudokuController>(
        init: controller,
        builder: (controller) {
          var chessboard = controller.chessboardModel?.board;
          var fills = controller.fills;
          return Row(
            children: [
              Center(
                child: Container(
                  width: itemW * itemNum + borderW * (groupItemNum + 1),
                  height: itemH * itemNum + borderW * (groupItemNum + 1),
                  color: Colors.black,
                  child: GestureDetector(
                      child: Container(
                        child: Column(
                          children:
                          List.generate(chessboard?.length ?? 0, (index) {
                            var rows = (chessboard ?? [])[index];
                            return Container(
                              width: groupW * groupItemNum +
                                  borderW * (groupItemNum + 1),
                              height: groupW,
                              color: Colors.black26,
                              margin: EdgeInsets.fromLTRB(0, borderW, 0, 0),
                              child: Row(
                                children: List.generate(rows.length, (index) {
                                  var group = rows[index];
                                  return Container(
                                    margin:
                                    EdgeInsets.fromLTRB(borderW, 0, 0, 0),
                                    child: SudokuGroup(
                                      groupData: group,
                                      rowW: groupW / 3,
                                      controller: controller,
                                    ),
                                  );
                                }),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      onVerticalDragUpdate: (details) {
                        // LoggerUtil.d('globalPosition dx:${details.globalPosition.dx}');
                        // LoggerUtil.d('globalPosition dy:${details.globalPosition.dy}');
                        // LoggerUtil.d('localPosition dx:${details.localPosition.dx}');
                        // LoggerUtil.d('localPosition dy:${details.localPosition.dy}');
                        onMove(
                            details.localPosition.dx, details.localPosition.dy);
                        // controller?.onTap(
                        //     gX: sudoku?.gX, gY: sudoku?.gY, pX: sudoku?.pX, pY: sudoku?.pY);
                      },
                      onVerticalDragEnd: (details) {},
                      onHorizontalDragUpdate: (details) {
                        // LoggerUtil.d('globalPosition dx:${details.globalPosition.dx}');
                        // LoggerUtil.d('globalPosition dy:${details.globalPosition.dy}');
                        // LoggerUtil.d('localPosition dx:${details.localPosition.dx}');
                        // LoggerUtil.d('localPosition dy:${details.localPosition.dy}');
                        onMove(
                            details.localPosition.dx, details.localPosition.dy);
                        // controller?.onTap(
                        //     gX: sudoku?.gX, gY: sudoku?.gY, pX: sudoku?.pX, pY: sudoku?.pY);
                      },
                      onHorizontalDragEnd: (details) {},
                      onTapUp: (details) {
                        onMove(
                            details.localPosition.dx, details.localPosition.dy);
                      }),
                ),
              ),
              Column(
                children: [
                  TextButton(
                      onPressed: () {
                        controller.initBoard();
                      },
                      child: Text('开始')),
                  TextButton(
                      onPressed: () {
                        controller.getCandidates();
                      },
                      child: Text('提示')),
                  TextButton(
                      onPressed: () {
                        SudokuManager.instance?.solvePuzzle();
                      },
                      child: Text('结果')),
                ],
              ),
              Container(
                width: itemW,
                height: itemW * fills.length,
                color: Colors.blue,
                child: SelectFills(
                    itemSize: itemW,
                    fills: fills,
                    onSelectFillItemCallback: (value) {
                      LoggerUtil.d(value);
                      controller.onSelect(value);
                    }),
              ),
              Column(
                children: [
                  _buildItem('','擦除',(){
                    controller.onErase();
                  }),
                  _buildDraft(controller?.isDraft ?? false),
                ],
              )
            ],
          );
        },
      ),
    ));
  }

  Widget _buildItem(String icon,String title,GestureTapCallback? onTap){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            Icon(Icons.delete),
            Text(title)
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDraft(bool isDraft){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            Icon(Icons.note,color: isDraft?Colors.blue:Colors.black,),
            Text('草稿',style: TextStyle(color: isDraft?Colors.blue:Colors.black),)
          ],
        ),
      ),
      onTap: (){
        controller.onSetDraft();
      },
    );
  }

  void onMove(double dx, double dy) {
    int pX = -1;
    int pY = -1;
    int gX = -1;
    int gY = -1;
    for (var i = 0; i < itemNum; i++) {
      if (dx > i * itemW && dx < (i + 1) * itemW) {
        pX = i;
      }
      if (dy > i * itemW && dy < (i + 1) * itemW) {
        pY = i;
      }
    }
    for (var i = 0; i < groupItemNum; i++) {
      if (dx > i * groupW && dx < (i + 1) * groupW) {
        gX = i;
      }
      if (dy > i * groupH && dy < (i + 1) * groupH) {
        gY = i;
      }
    }
    LoggerUtil.d('pX:$pX pY:$pY');
    controller.onTap(gX: gX, gY: gY, pX: pX, pY: pY);
  }
}
