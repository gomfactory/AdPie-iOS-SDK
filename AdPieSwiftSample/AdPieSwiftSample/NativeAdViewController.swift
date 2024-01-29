//
//  NativeAdViewController.swift
//  AdPieSwiftSample
//
//  Created by sunny on 2016. 10. 20..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

import UIKit
import AdPieSDK

class NativeAdViewController: UIViewController, APNativeDelegate {
    
    var nativeAd: APNativeAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 광고 객체 생성 (Slot ID 입력)
        nativeAd = APNativeAd(slotId: "580491a37174ea5279c5d09b")
        // 델리게이트 등록
        nativeAd.delegate = self
        
        // 광고 요청
        nativeAd.load()
        
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - APNative delegates
    func nativeDidLoad(_ nativeAd: APNativeAd!) {
        // 광고 요청 완료 후 이벤트 발생
        let nativeAdView = Bundle.main.loadNibNamed("AdPieNativeAdView", owner: nil, options: nil)?[0] as! APNativeAdView
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nativeAdView)
        NSLayoutConstraint.activate([
            nativeAdView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            nativeAdView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            nativeAdView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            nativeAdView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        // 광고뷰에 데이터 표출
        if nativeAdView.fillAd(nativeAd.nativeAdData) {
            // 광고 클릭 이벤트 수신을 위해 등록
            nativeAd.registerView(forInteraction: nativeAdView)
        } else {
            nativeAdView.removeFromSuperview()
            
            let errorMessage = "Failed to fill native ads data. Check your xib file."
            
            alertMessage(errorMessage)
        }
    }
    
    func nativeDidFail(toLoad nativeAd: APNativeAd!, withError error: Error!) {
        // 광고 요청 실패 후 이벤트 발생
        // error code : error._code
        // error message : error.localizedDescription
        
        let errorMessage = "Failed to load native ads." + "(code : " + String(error._code) + ", message : " + error.localizedDescription + ")"
        
        alertMessage(errorMessage)

    }
    
    func nativeWillLeaveApplication(_ nativeAd: APNativeAd!) {
        // 광고 클릭 후 이벤트 발생
    }
    
    func alertMessage(_ errorMessage : String) {
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            let alertView = UIAlertView(title: "Error", message: errorMessage, delegate: nil, cancelButtonTitle: "OK")
            alertView.alertViewStyle = .default
            alertView.show()
        }
    }
}
