//
//  UserDetailViewController.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import UIKit
import Base_swift

class UserDetailViewController: JetUIViewController<UserDetailView>  {
    
    var user: GitHubUser!

    override func onPresenterReady() {
        super.onPresenterReady()
        navigationItem.title = "User Details"
        if let userName = user.login {
            getUserDetail(userName)
        }
    }
    
    
    override func onExecuteCommand(command: any PCommand) throws {
        if let cmd = command as? UserDetailView.ClickBlogUrlCmd {
            openUserBlog(cmd.blogUrl)
        }
    }
    
    private func getUserDetail(_ userName: String) {
        let callback = JetActionCallback<GitHubUser>(context: self, onSuccess: {[weak self] data in
            guard let self = self, let d = data else {return}
            self.hideLoading()
            self.mvpView.updateUserDetail(d)
        }, onError: { err in
            self.hideLoading()
        })
        
        showLoading()
        actionManager.execute(action: GetUserDetailAction(),
                              input: GetUserDetailAction.RV(userName: userName),
                              callback: callback,
                              scheduler: AsyncScheduler(inConcurrent: true))
        .run()
    }
    
    private func openUserBlog(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
