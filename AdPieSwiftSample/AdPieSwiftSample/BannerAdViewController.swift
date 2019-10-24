//
//  BannerAdViewController.swift
//  AdPieSwiftSample
//
//  Created by sunny on 2016. 10. 20..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

import UIKit
import AdPieSDK

class BannerAdViewContoller: UIViewController, APAdViewDelegate {
    
    @IBOutlet weak var adViewResultLabel: UILabel!
    @IBOutlet weak var adView: APAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        adViewResultLabel.numberOfLines = 5
        
        // 광고뷰에 Slot ID 입력
        adView.slotId = "57342fdd7174ea39844cac15"
        // 광고뷰의 RootViewController 등록 (Refresh를 위해 필요)
        adView.rootViewController = self
        // 델리게이트 등록
        adView.delegate = self
        
        // 광고 요청
        adView.load()
        
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
    
    // MARK: - APAdView delegates
    
    func adViewDidLoadAd(_ view: APAdView!) {
        // 광고 표출 성공 후 이벤트 발생
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from:date)
        
        adViewResultLabel?.text = "Ad View Result : Success (date : \(dateString))"
    }
    
    func adViewDidFail(toLoadAd view: APAdView!, withError error: Error!) {
        // 광고 요청 또는 표출 실패 후 이벤트 발생
        // error code : error._code
        // error message : error.localizedDescription

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from:date)
        
        adViewResultLabel?.text = "Ad View Result : Error" + "(code : " + String(error._code) + ", message : " + error.localizedDescription + ", date : \(dateString))"

    }
    
    func adViewWillLeaveApplication(_ view: APAdView!) {
        // 광고 클릭 후 이벤트 발생
    }
}
