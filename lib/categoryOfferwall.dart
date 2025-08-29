import 'package:flutter/material.dart';
import 'package:pincrux_offerwall_flutter_plugin/pincruxOfferwallPlugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 카테고리 구분형 충전소 연결화면
class CategoryOfferwall extends StatefulWidget {
  @override
  State<CategoryOfferwall> createState() => _CategoryOfferwall();
}

class _CategoryOfferwall extends State<CategoryOfferwall> {
  int _finance = 0;
  int _cpa = 0;
  int _social = 0;
  int _cps = 0;
  int _game = 0;

  @override
  void initState() {
    super.initState();
    _initCategoryPoint();
  }

  Future<void> _initCategoryPoint() async {
    final preferences = await SharedPreferences.getInstance();
    final pubkey = preferences.getString('pubkey');

    // 사용자를 구분할 수 있는 유일한 키
    String usrkey = "YOUR_USER_KEY";
    setOfferwall(pubkey, usrkey, 2);

    final point = await PincruxOfferwallPlugin.getAdPoint(pubkey);

    setState(() {
      _finance = (point?['financePoint'] as num?)?.toInt() ?? 0;
      _cpa = (point?['cpaPoint'] as num?)?.toInt() ?? 0;
      _social = (point?['socialPoint'] as num?)?.toInt() ?? 0;
      _cps = (point?['cpsPoint'] as num?)?.toInt() ?? 0;
      _game = (point?['gamePoint'] as num?)?.toInt() ?? 0;
    });
  }

  void setOfferwall(String? pubkey, String usrkey, int offerwallType) {
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
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        title: "금융 적립",
        point: "${_finance}P",
        onPressed: () {
          PincruxOfferwallPlugin.setOfferwallCategory(1);
          PincruxOfferwallPlugin.startPincruxOfferwall();
        }
      ),
      (
        title: "참여 적립",
        point: "${_cpa}P",
        onPressed: () {
          PincruxOfferwallPlugin.setOfferwallCategory(2);
          PincruxOfferwallPlugin.startPincruxOfferwall();
        }
      ),
      (
        title: "구독 / 팔로우 / 퀵미션 적립",
        point: "${_social}P",
        onPressed: () {
          PincruxOfferwallPlugin.setOfferwallCategory(3);
          PincruxOfferwallPlugin.startPincruxOfferwall();
        }
      ),
      (
        title: "구매 적립",
        point: "${_cps}P",
        onPressed: () {
          PincruxOfferwallPlugin.setOfferwallCategory(4);
          PincruxOfferwallPlugin.startPincruxOfferwall();
        }
      ),
      (
        title: "게임 적립",
        point: "${_game}P",
        onPressed: () async {
          PincruxOfferwallPlugin.setOfferwallCategory(5);
          PincruxOfferwallPlugin.startPincruxOfferwall();
        }
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("PincruxCategoryOfferwall",
            style: TextStyle(fontSize: 24)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final it in items) ...[
                CategoryButton(title: it.title, point: it.point, onPressed: it.onPressed),
                const SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final String point;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.title,
    required this.point,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          Text(point),
        ],
      ),
    );
  }
}
