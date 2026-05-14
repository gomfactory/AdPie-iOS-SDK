import UIKit

extension UIViewController {
    private var topMostViewController: UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        var topController = keyWindow.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }

    func showToast(message: String) {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.alpha = 0.0
        
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.text = message
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(label)
        
        guard let targetView = topMostViewController?.view ?? self.view else { return }
        targetView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor),
            containerView.bottomAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: targetView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: targetView.trailingAnchor, constant: -20),
            
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
            containerView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
                containerView.alpha = 0.0
            }, completion: { _ in
                containerView.removeFromSuperview()
            })
        }
    }
}
