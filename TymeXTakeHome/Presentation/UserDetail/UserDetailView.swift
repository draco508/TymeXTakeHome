//
//  UserDetailView.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import UIKit
import Base_swift

class UserDetailView: MVPUIView {

    @IBOutlet weak var vUser: UIView!
    
    @IBOutlet weak var ivAvatar: UIImageView!
    
    @IBOutlet weak var lbFollowingCount: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbFollowersCount: UILabel!
    
    @IBOutlet weak var lbBlogUrl: UILabel!
    override func onInitView() {
        super.onInitView()
        vUser.addShadow()
        
    }
    
    func updateUserDetail(_ user: GitHubUser) {
        if let avatarURL = user.avatarURL {
            ivAvatar.load(urlString: avatarURL)
        }
        
        if let userName = user.login {
            lbUserName.text = userName
        } else {
            lbUserName.text = "-"
        }
        
        if let location = user.location {
            lbLocation.text = location
        } else {
            lbLocation.text = "-"
        }
        
        if let followers = user.followers {
            lbFollowersCount.text = "\(followers)+"
        } else {
            lbFollowersCount.text = "0"
        }
        
        if let following = user.following {
            lbFollowingCount.text = "\(following)+"
        } else {
            lbFollowingCount.text = "0"
        }
        
        if let blogUrl = user.blog {
            lbBlogUrl.text = blogUrl
            
            lbBlogUrl.setOnClickedListener { [weak self] in
                self?.presenter?.executeCommand(command: ClickBlogUrlCmd(blogUrl: blogUrl))
            }
        } else {
            lbBlogUrl.text = "-"
        }
        
    }
    
    struct ClickBlogUrlCmd: PCommand {
        let blogUrl: String
    }
}
