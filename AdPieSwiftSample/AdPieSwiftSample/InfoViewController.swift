//
//  InfoViewController.swift
//  AdPieSwiftSample
//
//  Created by sunny on 2016. 10. 21..
//  Copyright © 2016년 GomFactory. All rights reserved.
//

import AdPieSDK
import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var sdkInfoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sdkInfoLabel?.text = AdPieSDK.sdkVersion()
        
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

}
