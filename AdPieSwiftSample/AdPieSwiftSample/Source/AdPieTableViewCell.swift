import UIKit
import AdPieSDK

class AdPieTableViewCell: UITableViewCell {
    
    @IBOutlet var nativeAdView: APNativeAdView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
