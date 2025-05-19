//
//  UserCell.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import UIKit
import Base_swift

class UserCell: TableCell<GitHubUser> {

    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var ivAvatar: UIImageView!
    
    @IBOutlet weak var vRounded: UIView!
    @IBOutlet weak var lbUrl: UILabel!
    
    var onOpenUserLink:((String) -> Void)?
    
    override func initCell() {
        
        vRounded.addShadow()
        
        ivAvatar.layer.cornerRadius = ivAvatar.frame.size.width / 2
        ivAvatar.clipsToBounds = true
        
        lbUrl.setOnClickedListener { [weak self] in
            guard let self = self, let data = self.currentData as? GitHubUser else {return}
            if let htmlURL = data.htmlURL {
                self.onOpenUserLink?(htmlURL)
            }
        }
        
    }
    
    override func onBind(data: GitHubUser?) {
        if let user = data {
            lbUserName.text = user.login
            
            if let htmlURL = user.htmlURL {
                let attributedString = NSAttributedString(
                    string: htmlURL,
                    attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
                )
                
                lbUrl.attributedText = attributedString
            }
            
            
            if let avatarURL = user.avatarURL {
                ivAvatar.load(urlString: avatarURL)
            }
            
        }
        
    }
    
}
