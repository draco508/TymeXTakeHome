//
//  LoadMoreTableView.swift
//   
//
//  Created by admin on 18/04/2022.
//

import UIKit

class LoadMoreTableView: UITableView {

    private var loadMoreView: LoadMoreView!
    private var originContentInset: CGPoint?
    private let loadMoreDefaultHeight: CGFloat = 50
    
    var pullToRefreshListener: (() -> Void)?
    

    override func reloadData() {
        
        print("Reload Data")
        stopLoadMore()
        stopPullToRefresh()
        super.reloadData()
    }

    func addPullToRefresh() {

        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Kéo xuống để làm mới", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        refreshControl!.addTarget(self, action: #selector(self.refreshAction), for: .valueChanged)
    }
    
    func startPullToRefresh() {
        refreshControl?.beginRefreshing()
    }

    func stopPullToRefresh() {
        self.refreshControl?.endRefreshing()
    }
    
    func setSpinerBackground(_ color: UIColor) {
        loadMoreView.setSpinerBackground(color)
    }
    
    func addLoadMore(action: @escaping (() -> Void)) {
        let size = CGSize(width: self.frame.size.width, height: loadMoreDefaultHeight)
        let frame = CGRect(origin: .zero, size: size)
        loadMoreView = LoadMoreView(action: action, frame: frame)
        loadMoreView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(loadMoreView!)
    }

    func startLoadMore() {
        print("Start Load More")
        loadMoreView?.isLoading = true
    }

    func stopLoadMore() {
        print("Stop Load More")
        loadMoreView?.isLoading = false
    }

    func setLoadMoreEnable(_ enable: Bool) {
        loadMoreView?.isEnabled = enable
    }
    
    @objc private func refreshAction() {
        pullToRefreshListener?()
    }

}
