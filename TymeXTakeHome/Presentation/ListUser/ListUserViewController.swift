//
//  ListUserViewController.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import UIKit
import Base_swift

class ListUserViewController: JetUIViewController<ListUserView> {
    
    private var since: Int = 100
    private var perPage: Int = 20
    
    override func onPresenterReady() {
        super.onPresenterReady()
        
        getListUser()
    }
    
    override func onExecuteCommand(command: any PCommand) throws {
        if let cmd = command as? ListUserDataSource.OpenHtmlUrlCmd {
            openUserLink(cmd.htmlUrl)
        }
        
        if let cmd = command as? ListUserDataSource.ClickUserItemCmd {
            navigateToUserDetail(cmd.user)
        }
        
        if command is ListUserView.LoadMoreCmd {
            getListUser(true)
        }
    }
    
    private func getListUser(_ hasLoadMore: Bool = false) {
        
        if !hasLoadMore {
            since = 100
        }
        
        let callback = JetActionCallback<DataPage<GitHubUser>>(context: self, onSuccess: {[weak self] data in
            guard let self = self, let d = data else {return}
            self.hideLoading()
            self.mvpView.updateListUser(d.dataList, hasLoadMore)
            self.since = d.dataList.last?.id ?? 100
        }, onError: { [weak self] err in
            self?.hideLoading()
            self?.showAlert(title: "Error", message: err.message ?? "")
        })
        
        showLoading()
        actionManager.execute(action: GetListUserAction(),
                              input: GetListUserAction.RV(perPage: perPage, since: since),
                              callback: callback,
                              scheduler: AsyncScheduler(inConcurrent: true))
        .run()
    }
    
    private func openUserLink(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func navigateToUserDetail(_ user: GitHubUser) {
        let vc = UserDetailViewController()
        vc.user = user
        navi(to: vc)
    }
}
