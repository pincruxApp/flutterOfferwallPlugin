import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'offerwall.dart';

// PUBKEY 입력 화면
class Pubkey extends StatefulWidget {
  @override
  State<Pubkey> createState() => _Pubkey();
}

class _Pubkey extends State<Pubkey> {
  late SharedPreferences preferences;
  String? error;
  String labelText = "Pincrux에서 발급받은 Pubkey를 입력하세요.";

  TextEditingController textController = TextEditingController();

  Future<String> getPubkey() async {
    var pubkeyText;
    preferences = await SharedPreferences.getInstance();
    pubkeyText = preferences.get('pubkey');
    return pubkeyText ?? "";
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Offerwall()));
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
