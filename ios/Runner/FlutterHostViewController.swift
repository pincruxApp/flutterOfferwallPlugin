//
//  FlutterHostViewController.swift
//  Runner
//
//  iPhone Duo(iOS 27.1+)에서는 맨 위 화면이 "세로 바"를 끄지 않으면
//  시스템이 상태바를 화면 오른쪽 세로 열로 옮긴다.
//  Flutter 화면은 맨 위부터 타이틀을 그리므로, 세로 바를 꺼서 상태바를 늘 위쪽 가로에 둔다.
//  (오퍼월 SDK 화면은 SDK가 스스로 꺼 두었고, 이 클래스는 매체 앱 쪽 Flutter 화면용이다.)
//

import UIKit
@preconcurrency import Flutter

class FlutterHostViewController: FlutterViewController {
    @available(iOS 27.1, *)
    override var preferredVerticalBarBehavior: UIVerticalBarBehavior { .disabled }
}
