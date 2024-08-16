package com.example.pincrux_offerwall_flutter;

import android.content.Intent;

import androidx.annotation.NonNull;

import com.pincrux.offerwall.PincruxOfferwall;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String methodChannelName = "com.pincrux.offerwall.flutter";

    private final PincruxOfferwall offerwall = PincruxOfferwall.getInstance();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), methodChannelName)
                .setMethodCallHandler(((MethodCall call, MethodChannel.Result result) -> {
                    switch (call.method) {
                        case "init": {
                            String pubkey = call.argument("pubkey");
                            String usrkey = call.argument("usrkey");
                            offerwall.init(MainActivity.this, pubkey, usrkey);
                            break;
                        }

                        case "startOfferwall": {
                            offerwall.startPincruxOfferwallActivity(MainActivity.this);
                            break;
                        }

                        case "startPincruxOfferwallViewType": {
                            Intent intent = new Intent(MainActivity.this, ViewTypeActivity.class);
                            startActivity(intent);
                            break;
                        }

                        case "startPincruxOfferwallAdDetail": {
                            String appkey = call.argument("appkey");
                            offerwall.startPincruxOfferwallDetailActivity(MainActivity.this, appkey);
                            break;
                        }

                        case "startPincruxOfferwallContact": {
                            offerwall.startPincruxContactActivity(MainActivity.this);
                            break;
                        }

                        case "setOfferwallType": {
                            int type = call.argument("type");
                            offerwall.setOfferwallType(type);
                            break;
                        }

                        case "setEnableTab": {
                            boolean isEnable = call.argument("isEnable");
                            offerwall.setEnableTab(isEnable);
                            break;
                        }

                        case "setOfferwallTitle": {
                            String title = call.argument("title");
                            offerwall.setOfferwallTitle(title);
                            break;
                        }

                        case "setOfferwallThemeColor": {
                            String color = call.argument("color");
                            offerwall.setOfferwallThemeColor(color);
                            break;
                        }

                        case "setEnableScrollTopButton": {
                            boolean isEnable = call.argument("isEnable");
                            offerwall.setEnableScrollTopButton(isEnable);
                            break;
                        }

                        case "setAdDetail": {
                            boolean isEnable = call.argument("isEnable");
                            offerwall.setAdDetail(isEnable);
                            break;
                        }

                        // 개인정보 수집 및 이용 동의 기능으로 인해 삭제됨
//                        case "setDisableTermsPopup": {
//                            boolean isDisable = call.argument("isDisable");
//                            offerwall.setDisableTermsPopup(isDisable);
//                            break;
//                        }

                        case "setDisableCPS": {
                            boolean isDisable = call.argument("isDisable");
                            offerwall.setDisableCPS(isDisable);
                            break;
                        }

                        case "setDarkMode": {
                            int darkmode = call.argument("mode");
                            offerwall.setDarkMode(darkmode);
                            break;
                        }

                        default:
                            throw new IllegalStateException("Unexpected value: " + call.method);
                    }
                }));
    }
}
