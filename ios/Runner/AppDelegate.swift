import UIKit
@preconcurrency import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    var offerwallHandler: OfferwallMethodHandler?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 1. guard let을 사용하여 window와 controller를 안전하게 가져온다.
        guard let flutterVC = window?.rootViewController as? FlutterViewController else {
          fatalError("rootViewController is not a FlutterViewController")
        }

        // FlutterVC를 UINavigationController로 감싸 SDK(.NavigationPush) push가 가능하도록 한다.
        // SDK가 자체 NavBar를 그리므로 UINavigationController의 NavBar는 항상 숨김 처리한다.
        let navController = UINavigationController(rootViewController: flutterVC)
        navController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navController

        // Offerwall 채널 등록
        let offerwallChannel = FlutterMethodChannel(name: "com.pincrux.offerwall.flutter", binaryMessenger: flutterVC.binaryMessenger)
        offerwallHandler = OfferwallMethodHandler(controller: flutterVC)
        offerwallChannel.setMethodCallHandler { [weak self] (call, result) in
            self?.offerwallHandler?.handle(call: call, result: result)
        }

        GeneratedPluginRegistrant.register(with: flutterVC)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
