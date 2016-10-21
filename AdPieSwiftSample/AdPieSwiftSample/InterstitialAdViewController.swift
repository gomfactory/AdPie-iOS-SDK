//
//  InterstitialAdViewController.swift
//  AdPieSwiftSample
//
//  Created by sunny on 2016. 10. 20..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

import UIKit
import AdPieSDK

class InterstitialAdViewContoller: UIViewController, APInterstitialDelegate {
    
    var interstitial: APInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Slot ID 입력
        interstitial = APInterstitial(slotId: "573430057174ea39844cac16")
        // 델리게이트 등록
        interstitial.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func requestInterstitialAd(_ sender: UIButton) {
        // 광고 요청
        interstitial.load()
    }
    
    // MARK: - APInterstitial delegates
    
    func interstitialDidLoadAd(_ interstitial: APInterstitial!) {
        // 광고 로딩 완료 후 이벤트 발생
        
        // 광고 요청 후 즉시 노출하고자 할 경우 아래의 코드를 추가한다.
        if interstitial.isReady() {
            // 광고 표출
            interstitial.present(fromRootViewController: self)
        }
    }
    
    func interstitialDidFail(toLoadAd interstitial: APInterstitial!, withError error: Error!) {
        // 광고 요청 또는 표출 실패 후 이벤트 발생
        // error code : error._code
        // error message : error.localizedDescription
        
        let errorMessage = "Failed to load interstitial ads." + "(code : " + String(error._code) + ", message : " + error.localizedDescription + ")"
        
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
    
    func interstitialWillPresentScreen(_ interstitial: APInterstitial!) {
        // 광고 표출 후 이벤트 발생
    }
    
    
    func interstitialWillDismissScreen(_ interstitial: APInterstitial!) {
        // 광고가 표출한 뒤 종료하기 전에 이벤트 발생
    }
    
    func interstitialDidDismissScreen(_ interstitial: APInterstitial!) {
        // 광고가 표출한 뒤 종료한 후 이벤트 발생
    }
    
    func interstitialWillLeaveApplication(_ interstitial: APInterstitial!) {
        // 광고 클릭 후 이벤트 발생
    }
}
