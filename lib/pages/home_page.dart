import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sudoku_v2/apps/app_assets.dart';
import 'package:flutter_sudoku_v2/apps/app_theme.dart';
import 'package:get/get.dart';

import '../controller/sudoku_controller.dart';
import '../sudoku/difficulty_levels.dart';
import 'game_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<HomePage> {

  SudokuController controller = Get.put(SudokuController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  AppAssets.iconsJiangbei,
                  width: 26.h,
                  color: AppTheme.primaryColor,
                ),
                Image.asset(
                  AppAssets.iconsRicheng,
                  width: 26.h,
                  color: AppTheme.primaryColor,
                )
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  child: Container(
                    width: 200.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        color: AppTheme.primaryColor
                    ),
                    alignment: Alignment.center,
                    child: const Text('简单',style: TextStyle(color: Colors.white),),
                  ),
                  onTap: (){
                    controller.setLevel(DifficultyLevels.easy);
                    Get.to(const GamePage());
                  },
                ),
                Container(height: 8.h,),
                GestureDetector(
                  child: Container(
                    width: 200.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        color: AppTheme.primaryColor
                    ),
                    alignment: Alignment.center,
                    child: const Text('中等',style: TextStyle(color: Colors.white),),
                  ),
                  onTap: (){
                    controller.setLevel(DifficultyLevels.medium);
                    Get.to(const GamePage());
                  },
                ),
                Container(height: 8.h,),
                GestureDetector(
                  child: Container(
                    width: 200.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        color: AppTheme.primaryColor
                    ),
                    alignment: Alignment.center,
                    child: const Text('困难',style: TextStyle(color: Colors.white),),
                  ),
                  onTap: (){
                    controller.setLevel(DifficultyLevels.hard);
                    Get.to(const GamePage());
                  },
                ),
                Container(height: 8.h,),
                GestureDetector(
                  child: Container(
                    width: 200.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        color: AppTheme.primaryColor
                    ),
                    alignment: Alignment.center,
                    child: const Text('极难',style: TextStyle(color: Colors.white),),
                  ),
                  onTap: (){
                    controller.setLevel(DifficultyLevels.veryHard);
                    Get.to(const GamePage());
                  },
                ),
                Container(height: 8.h,),
                GestureDetector(
                  child: Container(
                    width: 200.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        color: AppTheme.primaryColor
                    ),
                    alignment: Alignment.center,
                    child: const Text('专家',style: TextStyle(color: Colors.white),),
                  ),
                  onTap: (){
                    controller.setLevel(DifficultyLevels.insane);
                    Get.to(const GamePage());
                  },
                ),
                Container(height: 8.h,),
                GestureDetector(
                  child: Container(
                    width: 200.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        color: AppTheme.primaryColor
                    ),
                    alignment: Alignment.center,
                    child: const Text('骨灰',style: TextStyle(color: Colors.white),),
                  ),
                  onTap: (){
                    controller.setLevel(DifficultyLevels.inhuman);
                    Get.to(const GamePage());
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  AppAssets.iconsBeibao,
                  width: 26.h,
                  color: AppTheme.primaryColor,
                ),
                Image.asset(
                  AppAssets.iconsMy,
                  width: 26.h,
                  color: AppTheme.primaryColor,
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
