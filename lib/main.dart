import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pincrux_offerwall_flutter/pincruxOfferwallPlugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;
const platform = MethodChannel("com.pincrux.offerwall.flutter");

void main() async {
  // main() 함수에서 async를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  // shared_preferences 인스턴스 생성
  preferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const Pubkey(),
    );
  }
}

// PUBKEY 입력 화면
class Pubkey extends StatefulWidget {
  const Pubkey({Key? key}) : super(key: key);

  @override
  State<Pubkey> createState() => _Pubkey();
}

class _Pubkey extends State<Pubkey> {
  String? error;
  String labelText = "Pincrux에서 발급받은 Pubkey를 입력하세요.";

  TextEditingController textController = TextEditingController();

  Future<String> getPubkey() async {
    var pubkeyText;
    preferences = await SharedPreferences.getInstance();
    pubkeyText = preferences.get('pubkey');
    return pubkeyText;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      textController.text = await getPubkey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "PincruxOfferwall Flutter",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: labelText,
                errorText: error,
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: () {
                  String pubkey = textController.text;
                  setState(() {
                    if (pubkey.isEmpty) {
                      error = labelText;
                    } else {
                      error = null;
                      preferences.setString("pubkey", pubkey);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Offerwall()),
                      );
                    }
                  });
                },
                child: const Text("다음"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 충전소 연결화면
class Offerwall extends StatefulWidget {
  const Offerwall({super.key});

  @override
  State<Offerwall> createState() => _OfferwallState();
}

class _OfferwallState extends State<Offerwall> {
  @override
  Widget build(BuildContext context) {
    print("pubkey=${preferences.getString("pubkey")}");

    // PINCRUX에서 발급받은 PUBKEY
    String? pubkey = preferences.getString("pubkey");
    // 사용자를 구분할 수 있는 유일한 키
    String usrkey = "YOUR_USER_KEY";

    void setOfferwall(String? pubkey, String usrkey, int offerwallType) {
      // 충전소 초기화
      PincruxOfferwallPlugin.init(pubkey, usrkey);

      // 충전소 광고리스트 탭 구분을 켜고 끌수 있습니다.
      PincruxOfferwallPlugin.setEnableTab(true);

      // 충전소 상단 타이틀 텍스트입니다.
      PincruxOfferwallPlugin.setOfferwallTitle("Flutter 충전소");

      // 충전소 테마 컬러(앞에 #을 생략해도되며 6자리 컬러를 입력하세요.)
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
    }

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
            width: double.infinity,
            height: 600,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BAR TYPE
                const Text(
                  "Offerwall(BAR TYPE)",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      ElevatedButton(
                        // Android Activity Type & iOS Modal Type
                        onPressed: () {
                          // 충전소 설정
                          setOfferwall(pubkey, usrkey, 1);

                          // iOS VC 설정
                          if (Platform.isIOS) {
                            // 충전소의 ViewController Type을 설정합니다.
                            // 1: Modal Type
                            // 2: View Type
                            PincruxOfferwallPlugin
                                .setOfferwallViewControllerType(1);
                          }

                          // 충전소를 실행합니다.
                          PincruxOfferwallPlugin.startPincruxOfferwall();
                        },
                        child: Text(Platform.isAndroid
                            ? "Activity Type"
                            : "Modal Type"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // 충전소 설정
                          setOfferwall(pubkey, usrkey, 1);

                          // iOS VC 설정
                          if (Platform.isIOS) {
                            // 충전소의 ViewController Type을 설정합니다.
                            // 1: Modal Type
                            // 2: View Type
                            PincruxOfferwallPlugin
                                .setOfferwallViewControllerType(2);
                          }

                          // 충전소를 View Type으로 실행합니다.
                          PincruxOfferwallPlugin
                              .startPincruxOfferwallViewType();
                        },
                        child: const Text("View Type"),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 30),

                // BAR PREMIUM TYPE
                const Text(
                  "Offerwall(BAR PREMIUM TYPE)",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      ElevatedButton(
                        // Android Activity Type & iOS Modal Type
                        onPressed: () {
                          // 충전소 설정
                          setOfferwall(pubkey, usrkey, 2);

                          // iOS VC 설정
                          if (Platform.isIOS) {
                            // 충전소의 ViewController Type을 설정합니다.
                            // 1: Modal Type
                            // 2: View Type
                            PincruxOfferwallPlugin
                                .setOfferwallViewControllerType(1);
                          }

                          // 충전소를 실행합니다.
                          PincruxOfferwallPlugin.startPincruxOfferwall();
                        },
                        child: Text(Platform.isAndroid
                            ? "Activity Type"
                            : "Modal Type"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // 충전소 설정
                          setOfferwall(pubkey, usrkey, 2);

                          // iOS VC 설정
                          if (Platform.isIOS) {
                            // 충전소의 ViewController Type을 설정합니다.
                            // 1: Modal Type
                            // 2: View Type
                            PincruxOfferwallPlugin
                                .setOfferwallViewControllerType(2);
                          }

                          // 충전소를 View Type으로 실행합니다.
                          PincruxOfferwallPlugin
                              .startPincruxOfferwallViewType();
                        },
                        child: const Text("View Type"),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 30),

                // PREMIUM TYPE
                const Text(
                  "Offerwall(PREMIUM TYPE)",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                          // Android Activity Type & iOS Modal Type
                          onPressed: () async {
                            // 충전소 설정
                            setOfferwall(pubkey, usrkey, 3);

                            // iOS VC 설정
                            if (Platform.isIOS) {
                              // 충전소의 ViewController Type을 설정합니다.
                              // 1: Modal Type
                              // 2: View Type
                              PincruxOfferwallPlugin
                                  .setOfferwallViewControllerType(1);
                            }

                            // 충전소를 실행합니다.
                            PincruxOfferwallPlugin.startPincruxOfferwall();
                          },
                          child: Text(Platform.isAndroid
                              ? "Activity Type"
                              : "Modal Type"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // 충전소 설정
                            setOfferwall(pubkey, usrkey, 3);

                            // iOS VC 설정
                            if (Platform.isIOS) {
                              // 충전소의 ViewController Type을 설정합니다.
                              // 1: Modal Type
                              // 2: View Type
                              PincruxOfferwallPlugin
                                  .setOfferwallViewControllerType(2);
                            }

                            // 충전소를 View Type으로 실행합니다.
                            PincruxOfferwallPlugin
                                .startPincruxOfferwallViewType();
                          },
                          child: const Text("View Type"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "부가기능",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),

                // Direct contact
                ElevatedButton(
                  onPressed: () {
                    // 충전소 설정
                    setOfferwall(pubkey, usrkey, 3);

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
                    setOfferwall(pubkey, usrkey, 3);

                    // 광고 상세에 필요한 appkey와 함께 광고 상세화면 호출 - 예시) DB손해보험(102011)
                    PincruxOfferwallPlugin.startPincruxOfferwallAdDetail(
                        "102011");
                  },
                  child: const Text("광고 상세 바로가기"),
                ),
              ],
            )),
      ),
    );
  }
}
