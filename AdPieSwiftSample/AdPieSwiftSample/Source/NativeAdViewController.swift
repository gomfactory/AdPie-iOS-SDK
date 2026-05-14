import UIKit
import AdPieSDK

enum TableItem {
    case content(String)
    case ad(APNativeAdData)
}

class NativeAdViewController: UITableViewController {
    
    // MARK: - Properties
    private let slotId: String
    private var nativeAd: APNativeAd?
    
    // Use Swift native Array instead of NSMutableArray
    private var items: [TableItem] = []
    
    // Position where the ad will be inserted
    private let adRowIndex = 10
    
    // MARK: - Init
    init(slotId: String) {
        self.slotId = slotId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAd()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Basic Setup
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        // Height Setup (Support Auto Layout)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        // Register Cells
        let adNib = UINib(nibName: "AdPieTableViewCell", bundle: nil)
        tableView.register(adNib, forCellReuseIdentifier: "AdPieTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    private func setupData() {
        // Generate items from 1 to 20
        items = (1...20).map { .content("Item \($0)") }
    }
    
    private func setupAd() {
        nativeAd = APNativeAd(slotId: self.slotId)
        nativeAd?.delegate = self
    }
    
    private func loadAd() {
        nativeAd?.load()
    }
}

// MARK: - UITableViewDataSource
extension NativeAdViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item {
        case .content(let text):
            // Normal Text Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = text
            cell.selectionStyle = .none
            return cell
            
        case .ad(let adData):
            // Ad Cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdPieTableViewCell", for: indexPath) as? AdPieTableViewCell else {
                return UITableViewCell()
            }
            // Bind Ad Data
            if cell.nativeAdView.fillAd(adData) {
                nativeAd?.registerView(forInteraction: cell.nativeAdView)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        switch item {
        case .ad:
            return 405.0
        case .content:
            return UITableView.automaticDimension
        }
    }
}

// MARK: - APNativeDelegate
extension NativeAdViewController: APNativeDelegate {
    
    func nativeDidLoad(_ nativeAd: APNativeAd!) {
        showToast(message: #function)
        guard let adData = nativeAd.nativeAdData else { return }
        // When ad data loads, insert it into the array at the specified index.
        // Safely check array bounds before insertion to prevent crashes.
        let insertIndex = min(adRowIndex, items.count)
        items.insert(.ad(adData), at: insertIndex)
        
        // Reload TableView
        tableView.reloadData()
    }
    
    func nativeDidFail(toLoad nativeAd: APNativeAd!, withError error: Error!) {
        showToast(message: #function)
        let nsError = error as NSError
        let errorMsg = String(format: "Error (code : %d, message : %@, date : %@)",
                              Int32(nsError.code),
                              nsError.localizedDescription,
                              Date().description(with: Locale.current))
        print("\(#function), \(errorMsg)")
    }
    
    func nativeWillLeaveApplication(_ nativeAd: APNativeAd!) {
        print(#function)
    }
}
