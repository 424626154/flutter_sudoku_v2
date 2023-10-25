import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sudoku_v2/apps/app_theme.dart';
import 'package:flutter_sudoku_v2/custom/select_fills.dart';
import 'package:flutter_sudoku_v2/dialog/game_over_diaolog.dart';
import 'package:flutter_sudoku_v2/models/board_model.dart';
import 'package:flutter_sudoku_v2/utils/logger_util.dart';
import 'package:flutter_sudoku_v2/utils/utils.dart';
import 'package:get/get.dart';

import '../controller/sudoku_controller.dart';
import '../custom/sudoku_group.dart';
import 'dart:async';

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
  double pading = 20.h;
  double itemNum = 9;
  double groupItemNum = 3;
  double groupW = 0;
  double groupH = 0;

  @override
  void initState() {
    super.initState();
    _onStartGame();
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
    var borderW = 1.w;
    return SafeArea(
        child: Scaffold(
      body: GetBuilder<SudokuController>(
        init: controller,
        builder: (controller) {
          var chessboard = controller.chessboardModel?.board;
          var fills = controller.fills;
          return Column(
            children: [
              _buildBar(),
              _buildHead(),
              Center(
                child: Container(
                  width: itemW * itemNum + borderW * (groupItemNum + 1),
                  height: itemH * itemNum + borderW * (groupItemNum + 1),
                  color: AppTheme.secondaryColor,
                  child: GestureDetector(
                      child: Column(
                        children:
                            List.generate(chessboard?.length ?? 0, (index) {
                          var rows = (chessboard ?? [])[index];
                          return Container(
                            width: groupW * groupItemNum +
                                borderW * (groupItemNum + 1),
                            height: groupW,
                            color: AppTheme.secondaryColor,
                            margin: EdgeInsets.fromLTRB(0, borderW, 0, 0),
                            child: Row(
                              children: List.generate(rows.length, (index) {
                                var group = rows[index];
                                return Container(
                                  margin: EdgeInsets.fromLTRB(borderW, 0, 0, 0),
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
              _buildTools(),
            ],
          );
        },
      ),
    ));
  }

  Widget _buildBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_rounded)),
          IconButton(
              onPressed: () {
                _onStartGame();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
    );
  }

  Widget _buildEraser(GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        child: Icon(Icons.delete_outline),
      ),
    );
  }

  Widget _buildDraft(bool isDraft) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(8.r),
        child: Icon(
          Icons.note_alt_outlined,
          color: isDraft ? AppTheme.primaryColor : Colors.black,
        ),
      ),
      onTap: () {
        controller.onSetDraft();
      },
    );
  }

  Widget _buildTips(int tipsNum) {
    return GestureDetector(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.r, 8.r, 8.r, 8.r),
            child: Icon(
              Icons.tips_and_updates_outlined,
              size: 24.r,
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 16.r,
              height: 16.r,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
              ),
              child: Center(
                child: Text(
                  '$tipsNum',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
      onTap: () {
        bool isTips = controller.onTips();
        if(isTips == false){
          LoggerUtil.d('提示次数已用完');
        }
      },
    );
  }

  Widget _buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(Utils.showCountDown(controller.duration ?? 0)),
        GestureDetector(
          child: Icon(
              controller.isTimer ? Icons.pause : Icons.not_started_outlined),
          onTap: () {
            if (controller.isTimer) {
              stopTimer();
            } else {
              startTimer();
            }
          },
        )
      ],
    );
  }

  Widget _buildTools() {
    return Padding(
      padding: EdgeInsets.fromLTRB(pading / 4, 0, pading / 4, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildDraft(controller.isDraft ?? false),
                  _buildTips(controller.tipsNum ?? 0),
                  _buildEraser(() {
                    controller.onErase();
                  }),
                ],
              ),
              _buildTimer()
            ],
          ),
          Divider(
            height: 4.h,
            thickness: 2.h,
            color: AppTheme.secondaryColor,
          ),
          Divider(
            height: 4.h,
            thickness: 2.h,
            color: AppTheme.cCCD0D9,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
            child: SelectFills(
                itemSize: ScreenUtil().screenWidth / 9,
                onSelectFillItemCallback: (value) {
                  LoggerUtil.d(value);
                  controller.onSelect(value, () {
                    showGameOverDialog();
                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildHead() {
    return Padding(
      padding: EdgeInsets.fromLTRB(pading / 4, 10.h, pading / 4, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${levelStr}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),

          Column(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '${controller.chessboardModel?.errorNumber}',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: '/${BoardModel.maxErrorNumber}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ]),
              ),
              Text(
                  '错误',style: TextStyle(color: AppTheme.cE9E9EC),),
            ],
          )
        ],
      ),
    );
  }

  void _onStartGame() {
    startTimer();
    controller.initBoard();
  }

  String get levelStr{
    var levelStr = '';
    switch(controller.level){
      case DifficultyLevels.easy:
        levelStr = '简单';
        break;
      case DifficultyLevels.medium:
        levelStr = '中等';
        break;
      case DifficultyLevels.hard:
        levelStr = '困难';
        break;
      case DifficultyLevels.veryHard:
        levelStr = '极难';
        break;
      case DifficultyLevels.insane:
        levelStr = '专家';
        break;
      case DifficultyLevels.inhuman:
        levelStr = '骨灰';
        break;
    }
    return levelStr;
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

  Timer? _timer;

  void startTimer() {
    if (_timer != null) {
      stopTimer();
    }
    controller.upTimer(true);
    //设置 1 秒回调一次
    const period = const Duration(milliseconds: 1);
    _timer = Timer.periodic(period, (timer) {
      controller?.addDuration(1);
    });
  }

  void stopTimer() {
    controller.upTimer(false);
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GameOverDialog(
            onRestart: () {
              _onStartGame();
            },
          ); //调用对话框
        });
  }
}
