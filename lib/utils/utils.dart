
class Utils {
  static String showCountDown(int times){
    int time = times~/1000;
    // var dInt = (time ~/ (60 *60 *24)); // 把秒数转换成天数  （parselnt把得到的数转换为整数）
    // var dStr = '';
    // if(dInt > 0)dStr = dInt < 10 ? '0$dInt' : '$dInt';//这里为了让时间数好看一点，比如把4天改成04天，所以加了三元判定，下面也是如此；
    // var hInt = (time ~/ (60*60)); //时
    // var hStr = '';
    // if(hInt > 0)hStr = hInt < 10 ? '0$hInt' : '$hInt';
    var mInt = (time ~/ (60)); //分
    var mStr = '00';
    if(mInt > 0)mStr = mInt < 10 ? '0$mInt' : '$mInt';
    var sInt = (time % 60); // 秒
    var sStr = '00';
    if(sInt > 0)sStr = sInt < 10 ? '0$sInt' : '$sInt';
    var timeStr = '';
    // if(dStr.isNotEmpty){
    //   timeStr = '$timeStr$dStr:';
    // }
    // if(hStr.isNotEmpty){
    //   timeStr = '$timeStr$hStr:';
    // }
    if(mStr.isNotEmpty){
      timeStr = '$timeStr$mStr:';
    }
    if(sStr.isNotEmpty){
      timeStr = '$timeStr$sStr';
    }
    return timeStr; //返回函数计算出的值

  }
}