import 'dart:io';

import 'package:flutter/services.dart';

class PincruxOfferwallPlugin {
  static const MethodChannel _channel = MethodChannel("com.pincrux.offerwall.flutter");

  static void init(String? pubkey, String? usrkey) async {
    await _channel.invokeListMethod("init", {'pubkey': pubkey, 'usrkey': usrkey});
  }

  // 충전소의 ViewController Type을 설정합니다. (iOS 전용)
  // 0: Push Type
  // 1: Modal Type
  // 2: View Type
  static void setOfferwallViewControllerType(int type) async {
    if (Platform.isIOS) {
      await _channel
          .invokeListMethod("setOfferwallViewControllerType", {'type': type});
    }
  }

  static void startPincruxOfferwall() async {
    await _channel.invokeMethod("startOfferwall");
  }

  static void startPincruxOfferwallViewType() async {
    await _channel.invokeMethod("startPincruxOfferwallViewType");
  }

  static void startPincruxOfferwallAdDetail(String? appkey) async {
    await _channel.invokeMethod("startPincruxOfferwallAdDetail", {'appkey': appkey});
  }

  static void startPincruxOfferwallContact() async {
    await _channel.invokeMethod("startPincruxOfferwallContact");
  }

  // Offerwall View Options
  static void setOfferwallType(int type) async {
    await _channel.invokeMethod("setOfferwallType", {'type': type});
  }

  static void setEnableTab(bool isEnable) async {
    await _channel.invokeMethod("setEnableTab", {'isEnable': isEnable});
  }

  static void setOfferwallTitle(String? title) async {
    await _channel.invokeMethod("setOfferwallTitle", {'title': title});
  }

  static void setOfferwallThemeColor(String? color) async {
    await _channel.invokeMethod("setOfferwallThemeColor", {'color': color});
  }

  static void setEnableScrollTopButton(bool isEnable) async {
    await _channel.invokeMethod("setEnableScrollTopButton", {'isEnable': isEnable});
  }

  static void setAdDetail(bool isEnable) async {
    await _channel.invokeMethod("setAdDetail", {'isEnable': isEnable});
  }

  static void setDisableCPS(bool isDisable) async {
    await _channel.invokeMethod("setDisableCPS", {'isDisable': isDisable});
  }

  static void setDarkMode(int mode) async {
    await _channel.invokeMethod("setDarkMode", {'mode': mode});
  }

  static void setOfferwallCategory(int category) async {
    await _channel.invokeMethod("setOfferwallCategory", {'category': category});
  }

  static void closeOfferwall() async {
    if (Platform.isIOS) {
      await _channel.invokeMethod("closeOfferwall");
    }
  }

  static Future<Map<String, dynamic>?> getAdPoint(String? pubkey) async {
    final result = await _channel.invokeMethod('getAdPoint', {'pubkey': pubkey});
    return (result as Map?)?.cast<String, dynamic>();
  }
}
