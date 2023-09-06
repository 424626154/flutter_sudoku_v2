
import 'dart:developer';

import 'package:logger/logger.dart';

///https://cloud.tencent.com/developer/article/1881689
var _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);



class LoggerUtil {
  static const String _defTag = 'logger_util';
  static bool _debugMode = true; //是否是debug模式,true: log v 不输出.
  static String _tagValue = _defTag;
  static void init({
    String tag = _defTag,
    bool isDebug = false,
  }) {
    _tagValue = tag;
    _debugMode = isDebug;
  }

  static void v(Object? object, {String? tag}) {
    if (_debugMode) {
      _logger.v('${tag ?? _tagValue} v | ${object?.toString()}');
    }
  }

  static void d(Object? object, {String? tag}) {
    if (_debugMode) {
      _logger.v('${tag ?? _tagValue} d | ${object?.toString()}');
    }
  }

  static void i(Object? object, {String? tag}) {
      _logger.v('${tag ?? _tagValue} i | ${object?.toString()}');
  }

  static void w(Object? object, {String? tag}) {
    _logger.w('${tag ?? _tagValue} w | ${object?.toString()}');
  }

  static void e(Object? object, {String? tag}) {
    _logger.w('${tag ?? _tagValue} e | ${object?.toString()}');
  }


  static void wtf(Object? object, {String? tag}) {
    _logger.wtf('${tag ?? _tagValue} wtf | ${object?.toString()}');
  }

  static void l(String message){
    log(message);
  }

}