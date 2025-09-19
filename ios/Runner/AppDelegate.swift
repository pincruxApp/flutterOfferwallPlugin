import UIKit
@preconcurrency import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    var offerwallHandler: OfferwallMethodHandler?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let offerwallChannel = FlutterMethodChannel(name: "com.pincrux.offerwall.flutter", binaryMessenger: controller.binaryMessenger)
        offerwallHandler = OfferwallMethodHandler(controller: controller)
        offerwallChannel.setMethodCallHandler { [weak self] (call, result) in
            self?.offerwallHandler?.handle(call: call, result: result)
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
