//
//  OfferwallMethodHandler.swift
//  Runner
//
//  Created by Melo on 9/18/25.
//

@preconcurrency import Flutter
import PincruxOfferwall
import UIKit

class OfferwallMethodHandler: NSObject {
    private weak var controller: FlutterViewController?
    private var offerwall: PincruxOfferwallSDK?
    private var categoryPoint: FlutterResult?

    init(controller: FlutterViewController) {
        self.controller = controller
    }

    @MainActor func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            if let args = call.arguments as? Dictionary<String, Any>,
               let pubkey = args["pubkey"] as? String,
               let usrkey = args["usrkey"] as? String {
                self.offerwall = PincruxOfferwallSDK.initWithPubkeyAndUsrkey(pubkey, usrkey)
            }

        case "setOfferwallViewControllerType":
            if let args = call.arguments as? Dictionary<String, Any>,
               let type = args["type"] as? Int {
                if type == 1 {
                    self.offerwall?.setViewControllerType(.Modal)
                } else if type == 2 {
                    self.offerwall?.setViewControllerType(.ViewType)
                }
            }

        case "startOfferwall":
            if let controller = controller {
                self.offerwall?.startOfferwall(vc: controller)
            }

        case "startPincruxOfferwallViewType":
            if let controller = controller {
                let viewtypeVC = UIViewController(nibName: "ViewTypeViewController", bundle: nil) as? ViewTypeViewController ?? ViewTypeViewController()
                controller.modalPresentationStyle = .fullScreen
                controller.present(viewtypeVC, animated: true)
            }

        case "startPincruxOfferwallAdDetail":
            if let args = call.arguments as? Dictionary<String, Any>,
            let appkey = args["appkey"] as? String,
               let controller = controller {
                self.offerwall?.startOfferwallDetailVC(vc: controller, appKey: appkey)
            }

        case "startPincruxOfferwallContact":
            if let controller = controller {
                self.offerwall?.startOfferwallContactVC(vc: controller)
            }

        case "setOfferwallType":
                if let args = call.arguments as? Dictionary<String, Any>,
                let type = args["type"] as? Int {
                    if type == 2 {
                        self.offerwall?.setOfferwallType(.BAR_PREMIUM_TYPE)
                    } else if type == 3 {
                        self.offerwall?.setOfferwallType(.PREMIUM_TYPE)
                    } else {
                        self.offerwall?.setOfferwallType(.BAR_TYPE)
                    }
                }

        case "setEnableTab":
            if let args = call.arguments as? Dictionary<String, Any>,
               let isEnable = args["isEnable"] as? Bool {
                self.offerwall?.setEnableTab(isEnable)
            }

        case "setOfferwallTitle":
            if let args = call.arguments as? Dictionary<String, Any>,
               let title = args["title"] as? String {
                self.offerwall?.setOfferwallTitle(title)
            }

        case "setOfferwallThemeColor":
            if let args = call.arguments as? Dictionary<String, Any>,
               let color = args["color"] as? String {
                self.offerwall?.setThemeColor(color)
            }

        case "setEnableScrollTopButton":
            if let args = call.arguments as? Dictionary<String, Any>,
               let isEnable = args["isEnable"] as? Bool {
                self.offerwall?.setEnableScrollTopButton(isEnable)
            }

        case "setAdDetail":
            if let args = call.arguments as? Dictionary<String, Any>,
               let isEnable = args["isEnable"] as? Bool {
                self.offerwall?.setAdDetail(isEnable)
            }

        case "setDisableCPS":
            if let args = call.arguments as? Dictionary<String, Any>,
               let isDisable = args["isDisable"] as? Bool {
                self.offerwall?.setDisableCPS(isDisable)
            }

        case "setDarkMode":
            if let args = call.arguments as? Dictionary<String, Any>,
               let mode = args["mode"] as? Int {
                switch mode {
                case 1:
                    self.offerwall?.setDarkMode(.LIGHT_ONLY)
                case 2:
                    self.offerwall?.setDarkMode(.DARK_ONLY)
                default:
                    self.offerwall?.setDarkMode(.AUTO)
                }
            }

        case "setOfferwallCategory":
            if let args = call.arguments as? Dictionary<String, Any>,
               let category = args["category"] as? Int {
                switch category {
                case 2:
                    self.offerwall?.setOfferwallCategory(.CPA)
                case 3:
                    self.offerwall?.setOfferwallCategory(.Social)
                case 4:
                    self.offerwall?.setOfferwallCategory(.CPS)
                case 5:
                    self.offerwall?.setOfferwallCategory(.Game)
                case 1:
                    fallthrough
                default:
                    self.offerwall?.setOfferwallCategory(.Finance)
                }
            }

        case "closeOfferwall":
            self.offerwall?.closeOfferwall()

        case "getAdPoint":
            if let args = call.arguments as? Dictionary<String, Any>,
               let pubkey = args["pubkey"] as? String {
                self.offerwall?.pointDelegate = self
                Task {
                    await self.offerwall?.getAdPoint(pubkey)
                }
                self.categoryPoint = result
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension OfferwallMethodHandler: OfferwallPointDelegate {
    func getAdPoint(_ point: OfferwallPointItems) async {
        let result: [String: Any] = [
            "financePoint": point.financeCoin,
            "cpaPoint": point.cpaCoin,
            "socialPoint": point.socialCoin,
            "cpsPoint": point.cpsCoin,
            "gamePoint": point.gameCoin
        ]

        DispatchQueue.main.async {
            self.categoryPoint?(result)
        }
    }
}
