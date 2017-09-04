//
//  RemoteConnectBannerCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 30/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol RemoteConnectBannerProtocol: class {
    func didTapOnConnectNow()
    func didTapOnDoNowShowAgain(cell: RemoteConnectBannerCell)
}


enum HeightForConnectBannerCell: CGFloat {
    case DefaultBannerSize = 128.0
}

class RemoteConnectBannerCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    weak var remoteConnectDelegate: RemoteConnectBannerProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    class func totalHeight() -> CGFloat {
        return HeightForConnectBannerCell.DefaultBannerSize.rawValue
    }
    
    @IBAction func connectNowTapped(sender: UIButton) {
        if let remoteConnectDelegate = remoteConnectDelegate {
            remoteConnectDelegate.didTapOnConnectNow()
        }
    }
    
    
    @IBAction func doNotShowAgainTapped(sender: UIButton) {
        if let remoteConnectDelegate = remoteConnectDelegate {
            remoteConnectDelegate.didTapOnDoNowShowAgain(cell: self)
        }
    }
}
