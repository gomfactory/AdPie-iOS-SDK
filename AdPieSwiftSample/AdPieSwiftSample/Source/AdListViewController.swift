
import UIKit
import AdPieSDK

// 1. Define Data Model
enum AdViewControllerType {
    case interstitial(String)
    case rewarded(String)
    case native(String)
    case banner(String)
    
    var viewController: UIViewController {
        switch self {
        case .interstitial(let slotId): return InterstitialAdViewController(slotId: slotId)
        case .rewarded(let slotId): return RewardedAdViewController(slotId: slotId)
        case .native(let slotId): return NativeAdViewController(slotId: slotId)
        case .banner(let slotId): return BannerAdViewController(slotId: slotId)
        }
    }
}

struct AdMenuItem {
    let title: String
    let subtitle: String
    let type: AdViewControllerType
}

class AdListViewController: UIViewController {

    // 2. Create TableView
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white // Overall background color
        tv.separatorStyle = .none   // Remove default separators (not needed for card style)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // List of data items
    private let items: [AdMenuItem] = [
        
        AdMenuItem(title: "Banner Ad", subtitle: "배너 광고", type: .banner("57342fdd7174ea39844cac15")),
        
        AdMenuItem(title: "Interstitial Ad", subtitle: "전면 광고", type: .interstitial("573430057174ea39844cac16")),
        
        AdMenuItem(title: "Rewarded Ad", subtitle: "리워드 광고", type: .rewarded("61de726d65a17f71c7896827")),
        
        AdMenuItem(title: "Native Ad", subtitle: "네이티브 광고", type: .native("580491a37174ea5279c5d09b"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        if let sdkVersion = AdPieSDK.sdkVersion() {
            self.title = "AdPie SDK v\(sdkVersion)"
        }
        
        view.addSubview(tableView)
        
        // Setup TableView Auto Layout
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Connect Delegate and DataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register Custom Cell
        tableView.register(AdListCell.self, forCellReuseIdentifier: "AdListCell")
    }
}

// 3. TableView Delegate & DataSource Extension
extension AdListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdListCell", for: indexPath) as? AdListCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(data: item)
        return cell
    }
    
    // Set cell height (using a fixed height here, or could use automaticDimension)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Card height + Spacing
    }
    
    // Handle cell selection (deselect immediately)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = items[indexPath.row]
        let destinationVC = selectedItem.type.viewController
        destinationVC.title = selectedItem.title
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(destinationVC, animated: true)
        } else {
            present(destinationVC, animated: true, completion: nil)
        }
    }
}

// 4. Custom Cell Class (Implement Card UI)
class AdListCell: UITableViewCell {
    
    // Card background (The colored box)
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Logo (AdPieX text)
    // Replacing with text and symbol since actual logo image is unavailable.
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "AdPieX"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 50/255, green: 80/255, blue: 120/255, alpha: 1.0) // Blue tone
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // English Title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Korean Subtitle
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // StackView to hold text labels
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none // Remove default gray selection background
        backgroundColor = .clear // Make the cell background itself transparent
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(logoLabel)
        containerView.addSubview(textStackView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Card(ContainerView) position: Add padding for floating effect
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Logo position (Left)
            logoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            logoLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logoLabel.widthAnchor.constraint(equalToConstant: 60), // Fixed width for logo area
            
            // Text stack position (Right of logo)
            textStackView.leadingAnchor.constraint(equalTo: logoLabel.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(data: AdMenuItem) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
}
