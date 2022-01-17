//
//  RewardedAdViewContoller.swift
//  AdPieSwiftSample
//
//  Created by sunny on 2016. 10. 20..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

import UIKit
import AdPieSDK

class RewardedAdViewContoller: UIViewController, APRewardedAdDelegate {
    
    var rewardedAd: APRewardedAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 광고 객체 생성 (Slot ID 입력)
        rewardedAd = APRewardedAd(slotId: "61de726d65a17f71c7896827")
        // 델리게이트 등록
        rewardedAd.delegate = self
        
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        }
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
    
    @IBAction func requestRewardedAd(_ sender: UIButton) {
        // 광고 요청
        rewardedAd.load()
    }
    
    // MARK: - APRewardedAdDelegate delegates
    func rewardedAdDidLoad(_ rewardedAd: APRewardedAd!) {
        // 광고 로딩 완료 후 이벤트 발생
        
        // 광고 요청 후 즉시 노출하고자 할 경우 아래의 코드를 추가한다.
        if rewardedAd.isReady() {
            // 광고 표출
            rewardedAd.present(fromRootViewController: self)
        }
    }
    
    func rewardedAdDidFail(toLoad rewardedAd: APRewardedAd!, withError error: Error!) {
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
    
    func rewardedAdWillPresentScreen(_ rewardedAd: APRewardedAd!) {
        // 리워드광고 표출 알림
    }
    
    func rewardedAdWillDismissScreen(_ rewardedAd: APRewardedAd!) {
        // 리워드광고 종료 예정 알림
    }
    
    func rewardedAdDidDismissScreen(_ rewardedAd: APRewardedAd!) {
        // 리워드광고 종료 완료 알림
    }
    
    func rewardedAdDidEarnReward(_ rewardedAd: APRewardedAd!) {
        // 리워드광고 보상 알림
    }
    
    func rewardedAdWillLeaveApplication(_ rewardedAd: APRewardedAd!) {
        // 리워드광고 클릭 알림
    }
}
