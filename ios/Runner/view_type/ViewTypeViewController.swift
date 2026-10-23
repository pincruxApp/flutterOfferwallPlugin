//
//  ViewTypeViewController.swift
//  Runner
//
//  Created by mason.kim on 2/13/24.
//

import Foundation
import UIKit
import PincruxOfferwall

class ViewTypeViewController : UIViewController {
    
    // iPhone Duo(iOS 27.1+): 뷰 타입은 매체 앱 화면 안에 오퍼월을 넣는 방식이라 세로 바는 매체 앱 화면이 정한다.
    // 이 샘플 화면에서 세로 바를 꺼서 상태바를 위쪽 가로에 둔다.
    @available(iOS 27.1, *)
    override var preferredVerticalBarBehavior: UIVerticalBarBehavior { .disabled }
    
    @IBOutlet weak var yourOfferwallView: UIView!
    
    var offerwall: PincruxOfferwallSDK?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.offerwall = PincruxOfferwallSDK.shared()
        self.offerwall?.viewtypeDelegate = self
        self.offerwall?.setViewControllerType(.ViewType)
        self.offerwall?.startOfferwall(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func enterForeground() {
        self.offerwall?.enterForeground()
    }
    
    @IBAction func onClose(_ sender: Any) {
        print("close")
        self.offerwall?.destroyView()
        self.dismiss(animated: true)
    }
}

extension ViewTypeViewController: OfferwallViewTypeDelegate {
    func offerwallReqClose() {
        print("offerwallReqClose")
        self.offerwall?.destroyView()
        self.dismiss(animated: true)
    }
    
    func offerwallInitSuccess() {
        print("offerwallInitSuccess")
    }
    
    func offerwallInitFailed(_ errCode: Int) {
        print("offerwallInitFailed : ", errCode)
    }
    
    func offerwallReceived(_ offerwallView: UIView) {
        if self.yourOfferwallView == nil {
            print("offerwallReceived : customView nil!!!")
            return
        }
        
        self.yourOfferwallView.addSubview(offerwallView)
        offerwallView.translatesAutoresizingMaskIntoConstraints = false
        offerwallView.topAnchor.constraint(equalTo: self.yourOfferwallView.topAnchor).isActive = true
        offerwallView.leftAnchor.constraint(equalTo: self.yourOfferwallView.leftAnchor).isActive = true
        offerwallView.rightAnchor.constraint(equalTo: self.yourOfferwallView.rightAnchor).isActive = true
        offerwallView.bottomAnchor.constraint(equalTo: self.yourOfferwallView.bottomAnchor).isActive = true
    }
    
    func offerwallAction() {
        print("offerwallAction")
    }
}
