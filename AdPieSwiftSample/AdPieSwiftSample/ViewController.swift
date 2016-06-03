//
//  ViewController.swift
//  AdPieSwiftSample
//
//  Created by KimYongSun on 2016. 5. 31..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

import UIKit
import AdPieSDK

class ViewController: UIViewController, APAdViewDelegate, APInterstitialDelegate {

    @IBOutlet weak var sdkVersionLabel: UILabel!
    
    @IBOutlet weak var adView: APAdView!
    
    var interstitial: APInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.sdkVersionLabel.text = self.sdkVersionLabel.text! + AdPieSDK.sdkVersion()
        
        // Slot ID 입력 (Banner)
        self.adView.slotId = "57342fdd7174ea39844cac15"
        // 델리게이트 등록 (Banner)
        self.adView.delegate = self
        
        // 광고 요청 (Banner)
        self.adView.load()
        
        // Slot ID 입력 (Interstitial)
        self.interstitial = APInterstitial(slotId: "573430057174ea39844cac16")
        // 델리게이트 등록 (Interstitial)
        self.interstitial.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestInterstitialAd(sender: UIButton) {
        // 광고 요청 (Interstitial)
        self.interstitial.load()
    }
    
    // MARK: - APAdView delegates
    
    func adViewDidLoadAd(view: APAdView!) {
        // 광고 표출 성공 후 이벤트 발생
    }
    
    func adViewDidFailToLoadAd(view: APAdView!, withError error: NSError!) {
        // 광고 요청 또는 표출 실패 후 이벤트 발생
        // error code : error.code
        // error message : error.localizedDescription
    }
    
    func adViewWillLeaveApplication(view: APAdView!) {
        // 광고 클릭 후 이벤트 발생
    }
    
    // MARK: - APInterstitial delegates
    
    func interstitialDidLoadAd(interstitial: APInterstitial!) {
        // 광고 로딩 완료 후 이벤트 발생
        
        // 광고 요청 후 즉시 노출하고자 할 경우 아래의 코드를 추가한다.
        if (self.interstitial.isReady()) {
            // 광고 표출
            self.interstitial.presentFromRootViewController(self)
        }
    }
    
    func interstitialDidFailToLoadAd(interstitial: APInterstitial!, withError error: NSError!) {
        // 광고 요청 또는 표출 실패 후 이벤트 발생
        // error code : error.code
        // error message : error.localizedDescription
        
        let errorMessage = "Failed to load interstitial ads." + "(code : " + String(error.code) + ", message : " + error.localizedDescription + ")"
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertView = UIAlertView(title: "Error", message: errorMessage, delegate: nil, cancelButtonTitle: "OK")
            alertView.alertViewStyle = .Default
            alertView.show()
        }
    }
    
    func interstitialWillPresentScreen(interstitial: APInterstitial!) {
        // 광고 표출 후 이벤트 발생
    }
    
    
    func interstitialWillDismissScreen(interstitial: APInterstitial!) {
        // 광고가 표출한 뒤 종료하기 전에 이벤트 발생
    }
    
    func interstitialDidDismissScreen(interstitial: APInterstitial!) {
        // 광고가 표출한 뒤 종료한 후 이벤트 발생
    }
    
    func interstitialWillLeaveApplication(interstitial: APInterstitial!) {
        // 광고 클릭 후 이벤트 발생
    }

}

