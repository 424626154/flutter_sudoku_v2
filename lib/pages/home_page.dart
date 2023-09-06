import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sudoku_v2/apps/app_assets.dart';
import 'package:flutter_sudoku_v2/apps/app_theme.dart';
import 'package:get/get.dart';

import 'game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<HomePage> {
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        color: AppTheme.primaryColor
                    ),
                    alignment: Alignment.center,
                    child: const Text('单机模式',style: TextStyle(color: Colors.white),),
                  ),
                  onTap: (){
                    Get.to(const GamePage());
                  },
                )
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
