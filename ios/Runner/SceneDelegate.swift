//
//  SceneDelegate.swift
//  Runner
//
//  iOS 27부터 UIScene 생명주기를 쓰지 않는 앱은 실행 직후 시스템이 멈춰 버린다.
//  그래서 Flutter 기본 씬 담당(FlutterSceneDelegate)을 그대로 쓰되,
//  화면이 연결되는 순간 첫 Flutter 화면을 내비게이션으로 한 번 감싸 준다.
//  (예전에는 AppDelegate 의 앱 시작 시점에서 하던 일을 이곳으로 옮긴 것)
//

import UIKit
@preconcurrency import Flutter

class SceneDelegate: FlutterSceneDelegate {
    override func scene(_ scene: UIScene,
                        willConnectTo session: UISceneSession,
                        options connectionOptions: UIScene.ConnectionOptions) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        // 스토리보드가 만든 첫 화면(FlutterViewController)을 꺼내 내비게이션으로 감싼다.
        // 오퍼월을 PUSH 방식으로 띄우려면 내비게이션이 있어야 하기 때문이다.
        // 오퍼월이 자체 상단바를 그리므로 내비게이션의 상단바는 항상 숨긴다.
        guard let flutterVC = window?.rootViewController as? FlutterViewController else { return }
        let navController = UINavigationController(rootViewController: flutterVC)
        navController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navController
    }
}
