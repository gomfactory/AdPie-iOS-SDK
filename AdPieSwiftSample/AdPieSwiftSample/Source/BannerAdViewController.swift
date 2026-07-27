import UIKit
import AdPieSDK

class BannerAdViewController: UIViewController, APAdViewDelegate {
    
    private var slotId: String?
    private var bannerView: APAdView!
    
    init(slotId: String?) {
        self.slotId = slotId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Load Ad
        bannerView.load()
    }
    
    private func setupUI() {
        // Banner View
        bannerView = APAdView()
        bannerView.slotId = slotId
        bannerView.delegate = self
        bannerView.rootViewController = self
        
        // AutoLayout
        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        bannerView.onPaidEvent = { ecpm in
            print("onPaidEvent, ecpm: \(ecpm)")
        }
    }
    
    // MARK: - APAdView delegates
    
    func adViewDidLoadAd(_ view: APAdView!) {
        showToast(message: "\(#function)")
        print("\(#function)")
    }
    
    func adViewDidFail(toLoadAd view: APAdView!, withError error: Error!) {
        showToast(message: "\(#function)")
        let nsError = error as NSError
        let errorMsg = String(format: "Error (code : %d, message : %@, date : %@)",
                              Int32(nsError.code),
                              nsError.localizedDescription,
                              Date().description(with: Locale.current))
        print("\(#function), \(errorMsg)")
    }
    
    func adViewWillLeaveApplication(_ view: APAdView!) {
        print("\(#function)")
    }
}
