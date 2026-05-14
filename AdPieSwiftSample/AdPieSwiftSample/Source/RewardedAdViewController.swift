import UIKit
import AdPieSDK

class RewardedAdViewController: UIViewController {

    let slotId: String
    var rewardedAd: APRewardedAd?
    
    init(slotId: String) {
        self.slotId = slotId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load Ad", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return button
    }()

    private let showButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Ad", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return button
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }

    private func setupUI() {
        stackView.addArrangedSubview(loadButton)
        stackView.addArrangedSubview(showButton)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        loadButton.addTarget(self, action: #selector(didTapLoadAdButton), for: .touchUpInside)
        showButton.addTarget(self, action: #selector(didTapShowAdButton), for: .touchUpInside)
    }
    
    @objc private func didTapLoadAdButton() {
        self.rewardedAd = APRewardedAd(slotId: self.slotId)
        self.rewardedAd?.delegate = self
        self.rewardedAd?.load()
    }
    
    @objc private func didTapShowAdButton() {
        guard let rewardedAd = self.rewardedAd else { return }
        guard rewardedAd.isReady() == true else { return }
        rewardedAd.present(fromRootViewController: self)
    }
}

extension RewardedAdViewController: APRewardedAdDelegate {

    // MARK: - APRewardedAdDelegate delegates
    func rewardedAdDidLoad(_ rewardedAd: APRewardedAd!) {
        showToast(message: #function)
        print(#function)
    }
    
    func rewardedAdDidFail(toLoad rewardedAd: APRewardedAd!, withError error: Error!) {
        showToast(message: #function)
        let errorMessage = "Failed to load interstitial ads." + "(code : " + String(error._code) + ", message : " + error.localizedDescription + ")"
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func rewardedAdDidFail(toShow rewardedAd: APRewardedAd!, withError error: Error!) {
        showToast(message: #function)
        print(#function)
    }
    
    func rewardedAdDidDismissScreen(_ rewardedAd: APRewardedAd!) {
        showToast(message: #function)
        print(#function)
    }
    
    func rewardedAdDidEarnReward(_ rewardedAd: APRewardedAd!) {
        showToast(message: #function)
        print(#function)
    }
    
    func rewardedAdWillPresentScreen(_ rewardedAd: APRewardedAd!) {
        print(#function)
    }
    
    func rewardedAdWillDismissScreen(_ rewardedAd: APRewardedAd!) {
        print(#function)
    }
    
    func rewardedAdWillLeaveApplication(_ rewardedAd: APRewardedAd!) {
        print(#function)
    }
    
    func rewardedVideoFinished(_ finishState: APVideoFinishState) {
        print(#function)
    }
    
    func rewardedVideoFinished(_ rewardedAd: APRewardedAd!, videoFinishState: APVideoFinishState) {
        print(#function)
    }

}
