import UIKit
@preconcurrency import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate, @preconcurrency FlutterImplicitEngineDelegate {
    var offerwallHandler: OfferwallMethodHandler?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 화면 구성(첫 화면을 내비게이션으로 감싸기)은 SceneDelegate 에서 한다.
        // 채널·플러그인 등록은 Flutter 엔진이 준비된 뒤 아래 콜백에서 한다.
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // UIScene 방식에서는 Flutter 엔진이 씬 연결 뒤에 만들어지므로,
    // 엔진이 준비됐다는 이 신호를 받은 다음에 플러그인과 Offerwall 채널을 등록한다.
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

        // Offerwall 채널 등록
        let offerwallChannel = FlutterMethodChannel(name: "com.pincrux.offerwall.flutter",
                                                    binaryMessenger: engineBridge.applicationRegistrar.messenger())
        offerwallHandler = OfferwallMethodHandler()
        offerwallChannel.setMethodCallHandler { [weak self] (call, result) in
            self?.offerwallHandler?.handle(call: call, result: result)
        }
    }
}
