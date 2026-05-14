import UIKit
import AdPieSDK

class InterstitialAdViewController: UIViewController {

    let slotId: String
    var interstitial: APInterstitial?
    
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
        self.interstitial = APInterstitial(slotId: self.slotId)
        self.interstitial?.delegate = self
        self.interstitial?.load()
    }
    
    @objc private func didTapShowAdButton() {
        guard let interstitial = self.interstitial else { return }
        guard interstitial.isReady() == true else { return }
        interstitial.present(fromRootViewController: self)
    }
}

extension InterstitialAdViewController: APInterstitialDelegate {
    
    // MARK: - APInterstitial delegates
    
    func interstitialDidLoadAd(_ interstitial: APInterstitial!) {
        showToast(message: #function)
        print(#function)
    }
    
    func interstitialDidFail(toLoadAd interstitial: APInterstitial!, withError error: Error!) {
        showToast(message: #function)
        let errorMessage = "Failed to load interstitial ads." + "(code : " + String(error._code) + ", message : " + error.localizedDescription + ")"
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func interstitialDidFail(toShowAd interstitial: APInterstitial!, withError error: (any Error)!) {
        showToast(message: #function)
        print(#function)
    }
    
    func interstitialDidDismissScreen(_ interstitial: APInterstitial!) {
        showToast(message: #function)
        print(#function)
    }
    
    func interstitialWillPresentScreen(_ interstitial: APInterstitial!) {
        print(#function)
    }
    
    func interstitialWillDismissScreen(_ interstitial: APInterstitial!) {
        print(#function)
    }
    
    func interstitialWillLeaveApplication(_ interstitial: APInterstitial!) {
        print(#function)
    }
    
}

