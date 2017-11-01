//
//  NativeAdTableViewController.swift
//  AdPieSwiftSample
//
//  Created by sunny on 2016. 10. 20..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

import UIKit
import AdPieSDK

class NativeAdTableViewController: UITableViewController, APNativeDelegate {
    
    var nativeAd: APNativeAd!
    
    var itemsArray: NSMutableArray!
    var adViewDictionary: NSMutableDictionary!
    var adRowIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // navigationItem.rightBarButtonItem = editButtonItem()
        
        // 동적으로 셀의 크기 지정
        if #available(iOS 8.0, *) {
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.estimatedRowHeight = 300;
        }
        
        // 샘플 컨텐츠를 위한 xib 등록
        tableView.register(UINib.init(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleTableViewCell")
        
        // 데이터 저장을 위한 배열 생성
        itemsArray = NSMutableArray()
        
        for index in 1...20{
            let item = "Item \(index)"
            itemsArray.add(item)
        }

        // 광고가 존재하는 테이블뷰 셀을 저장하기 위해 생성
        adViewDictionary = NSMutableDictionary()
        
        // 광고의 테이블 인덱스
        adRowIndex = 10
        
        // 광고를 위한 xib 파일 등록
        tableView.register(UINib.init(nibName: "AdPieTableViewCell", bundle: nil), forCellReuseIdentifier: "AdPieTableViewCell")
        
        // 광고 객체 생성 (Slot ID 입력)
        nativeAd = APNativeAd(slotId: "580491a37174ea5279c5d09b")
        // 델리게이트 등록
        nativeAd.delegate = self
        
        // 광고 요청
        nativeAd.load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if itemsArray.object(at: indexPath.row) is APNativeAdData {
            let cellIdentifier = "AdPieTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AdPieTableViewCell
            
            adViewDictionary?[String(format: "%@_%d", cellIdentifier,indexPath.row)] = cell
            
            let nativeAdData = itemsArray.object(at: indexPath.row) as? APNativeAdData
            
            // 광고뷰에 데이터 표출
            if cell.nativeAdView.fillAd(nativeAdData) {
                // 광고 클릭 이벤트 수신을 위해 등록
                nativeAd.registerView(forInteraction: cell.nativeAdView)
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableViewCell", for: indexPath)
            cell.textLabel?.text = itemsArray.object(at: indexPath.row) as? String
            
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if itemsArray.object(at: indexPath.row) is APNativeAdData {
            
            var isValidLayout: Bool = false
            
            let cellIdentifier = "AdPieTableViewCell"
            
            if let cell = adViewDictionary?.object(forKey: String(format: "%@_%d", cellIdentifier,indexPath.row)) {
                isValidLayout = (cell as! AdPieTableViewCell).nativeAdView.isValidLayout
            }
            
            if isValidLayout {
                if #available(iOS 8.0, *) {
                    return UITableViewAutomaticDimension
                } else {
                    return 300;
                }
            } else {
                return 0
            }
        } else {
            if #available(iOS 8.0, *) {
                return UITableViewAutomaticDimension
            } else {
                return tableView.rowHeight
            }
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - APNative delegates
    
    func nativeDidLoad(_ nativeAd: APNativeAd!) {
        // 광고 요청 완료 후 이벤트 발생
        if nativeAd.nativeAdData != nil {
            if itemsArray.object(at: adRowIndex) is APNativeAdData {
                itemsArray.replaceObject(at: adRowIndex, with: nativeAd.nativeAdData)
            } else {
                itemsArray.insert(nativeAd.nativeAdData, at: adRowIndex)
            }
        }
        
        tableView.reloadData()
    }
    
    func nativeDidFail(toLoad nativeAd: APNativeAd!, withError error: Error!) {
        // 광고 요청 실패 후 이벤트 발생
        // error code : error._code
        // error message : error.localizedDescription
        
        let errorMessage = "Failed to load native ads." + "(code : " + String(error._code) + ", message : " + error.localizedDescription + ")"
        
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
    
    func nativeWillLeaveApplication(_ nativeAd: APNativeAd!) {
        // 광고 클릭 후 이벤트 발생
    }
}
