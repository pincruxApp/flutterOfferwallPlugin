import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pincrux_offerwall_flutter_plugin/pincruxOfferwallPlugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'categoryOfferwall.dart';

// 충전소 연결화면
class Offerwall extends StatefulWidget {
  @override
  State<Offerwall> createState() => _Offerwall();
}

class _Offerwall extends State<Offerwall> {
  String? _pubkey;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    final preferences = await SharedPreferences.getInstance();
    final pubkey = preferences.getString('pubkey');
    setState(() {
      _pubkey = pubkey;
    });
  }

  void _setOfferwall(String? pubkey, String usrkey, int offerwallType) {
    // 충전소 초기화
    PincruxOfferwallPlugin.init(pubkey, usrkey);

    // 충전소 광고리스트 탭 구분을 켜고 끌수 있습니다.
    PincruxOfferwallPlugin.setEnableTab(true);

    // 충전소 상단 타이틀 텍스트입니다.
    PincruxOfferwallPlugin.setOfferwallTitle("Flutter 충전소");

    // 충전소 테마 컬러(앞에 #을 생략해도되며 6자리 컬러를 입력하세요.)
    // 테마 컬러를 설정하지 않으면 PINCRUX 서버에 지정된 매체별 테마색상이 적용됩니다.
    PincruxOfferwallPlugin.setOfferwallThemeColor("#3383FD");

    // 충전소 광고리스트에서 맨위로 버튼을 보이거나 숨깁니다.
    PincruxOfferwallPlugin.setEnableScrollTopButton(true);

    // 충전소의 광고타입이 BAR 타입일 경우 광고 클릭시 광고 상세 화면으로 이동합니다.
    // BAR_PREMIUM, PREMIUM 타입은 아래 옵션과 상관없이 광고 상세 화면으로 이동합니다.
    PincruxOfferwallPlugin.setAdDetail(true);

    // 이용 동의 철회 기능으로 삭제됨
    //PincruxOfferwallPlugin.setDisableTermsPopup(false);

    // 충전소에서 CPS 광고를 제거하거나 노출합니다.
    PincruxOfferwallPlugin.setDisableCPS(false);

    // 충전소 다크모드 설정을 합니다.
    // AUTO : 0
    // LIGHT_ONLY : 1
    // DARK_ONLY : 2
    PincruxOfferwallPlugin.setDarkMode(0);

    // 충전소의 리스트 타입을 설정합니다.
    // BAR TYPE : 1
    // BAR PREMIUM TYPE : 2
    // PREMIUM TYPE : 3
    PincruxOfferwallPlugin.setOfferwallType(offerwallType);

    // (iOS 한정) 충전소 종료가 필요 할 때 요청합니다.
    // PincruxOfferwallPlugin.closeOfferwall();
  }

  // 충전소 리스트 타입 1개 섹션(제목 + 실행 버튼들)을 만듭니다.
  // offerwallType은 _setOfferwall에 그대로 전달됩니다.
  // BAR TYPE : 1
  // BAR PREMIUM TYPE : 2
  // PREMIUM TYPE : 3
  Widget _buildOfferwallSection({
    required String title,
    required int offerwallType,
    required String? pubkey,
    required String usrkey,
  }) {
    final buttons = <Widget>[
      // iOS Push Type
      // 충전소를 UINavigationController에 push 하여 실행합니다.
      // Android는 Activity로 실행되어 push 개념이 없으므로 노출하지 않습니다.
      if (Platform.isIOS)
        ElevatedButton(
          onPressed: () {
            // 충전소 설정
            _setOfferwall(pubkey, usrkey, offerwallType);

            // iOS VC 설정
            // 충전소의 ViewController Type을 설정합니다.
            // 0: Push Type
            // 1: Modal Type
            // 2: View Type
            PincruxOfferwallPlugin.setOfferwallViewControllerType(0);

            // 충전소를 실행합니다.
            PincruxOfferwallPlugin.startPincruxOfferwall();
          },
          child: const Text("Push Type"),
        ),

      ElevatedButton(
        // Android Activity Type & iOS Modal Type
        onPressed: () {
          // 충전소 설정
          _setOfferwall(pubkey, usrkey, offerwallType);

          // iOS VC 설정
          if (Platform.isIOS) {
            // 충전소의 ViewController Type을 설정합니다.
            // 0: Push Type
            // 1: Modal Type
            // 2: View Type
            PincruxOfferwallPlugin.setOfferwallViewControllerType(1);
          }

          // 충전소를 실행합니다.
          PincruxOfferwallPlugin.startPincruxOfferwall();
        },
        child: Text(Platform.isAndroid ? "Activity Type" : "Modal Type"),
      ),

      ElevatedButton(
        onPressed: () {
          // 충전소 설정
          _setOfferwall(pubkey, usrkey, offerwallType);

          // iOS VC 설정
          if (Platform.isIOS) {
            // 충전소의 ViewController Type을 설정합니다.
            // 0: Push Type
            // 1: Modal Type
            // 2: View Type
            PincruxOfferwallPlugin.setOfferwallViewControllerType(2);
          }

          // 충전소를 View Type으로 실행합니다.
          PincruxOfferwallPlugin.startPincruxOfferwallViewType();
        },
        child: const Text("View Type"),
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),

        // 저해상도 기기에서 가로 스크롤이 생기지 않도록 한 줄에 최대 2개씩 배치합니다.
        // 각 버튼은 Expanded로 절반 너비를 차지해 줄이 바뀌어도 열이 맞습니다.
        for (int i = 0; i < buttons.length; i += 2) ...[
          Row(
            children: [
              Expanded(child: buttons[i]),
              const SizedBox(width: 10),
              Expanded(
                child: i + 1 < buttons.length
                    ? buttons[i + 1]
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          if (i + 2 < buttons.length) const SizedBox(height: 10),
        ],

        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("pubkey=${_pubkey}");

    // PINCRUX에서 발급받은 PUBKEY
    String? pubkey = _pubkey;

    // 사용자를 구분할 수 있는 유일한 키
    String usrkey = "YOUR_USER_KEY";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "PincruxOfferwall Flutter",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            // 높이를 고정하지 않고 내용에 맞춥니다.
            // 버튼이 2줄로 늘어나거나 기기 높이가 작아도 오버플로 없이 스크롤됩니다.
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BAR TYPE
                _buildOfferwallSection(
                  title: "Offerwall(BAR TYPE)",
                  offerwallType: 1,
                  pubkey: pubkey,
                  usrkey: usrkey,
                ),

                // BAR PREMIUM TYPE
                _buildOfferwallSection(
                  title: "Offerwall(BAR PREMIUM TYPE)",
                  offerwallType: 2,
                  pubkey: pubkey,
                  usrkey: usrkey,
                ),

                // PREMIUM TYPE
                _buildOfferwallSection(
                  title: "Offerwall(PREMIUM TYPE)",
                  offerwallType: 3,
                  pubkey: pubkey,
                  usrkey: usrkey,
                ),

                const Text(
                  "부가기능",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),

                // Direct contact
                ElevatedButton(
                  onPressed: () {
                    // 충전소 설정
                    _setOfferwall(pubkey, usrkey, 3);

                    // 문의하기 바로 가기 기능 호출
                    PincruxOfferwallPlugin.startPincruxOfferwallContact();
                  },
                  child: const Text("문의하기 바로가기"),
                ),
                const SizedBox(height: 20),

                // Direct ad detail
                ElevatedButton(
                  onPressed: () {
                    // 충전소 설정
                    _setOfferwall(pubkey, usrkey, 3);

                    // 광고 상세에 필요한 appkey와 함께 광고 상세화면 호출 - 예시) DB손해보험(102011)
                    PincruxOfferwallPlugin.startPincruxOfferwallAdDetail(
                        "102011");
                  },
                  child: const Text("광고 상세 바로가기"),
                ),
                const SizedBox(height: 20),
                // Direct ad detail
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryOfferwall()));
                  },
                  child: const Text("카테고리 충전소"),
                ),
              ],
            )),
      ),
    );
  }
}
