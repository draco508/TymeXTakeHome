//
//  LoadMoreView2.swift
//   
//
//  Created by admin on 18/04/2022.
//

import UIKit

class LoadMoreView: UIView {
    
    // Default is true. When you set false load more view will be hide
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                frame = CGRect(x: 0, y: tableView.contentSize.height, width: frame.size.width, height: height)
            } else {
                frame = CGRect(x: 0, y: tableView.contentSize.height, width: frame.size.width, height: 0)
            }
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
    
    private var height: CGFloat = 50
    private weak var tableView: UITableView!
    private var contentOffsetObservation: NSKeyValueObservation?
    private var contentSizeObservation: NSKeyValueObservation?
    private var panStateObservation: NSKeyValueObservation?

    private var spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var action: (() -> Void) = {}
    
    convenience init(action: @escaping (() -> ()), frame: CGRect) {
        
        self.init(frame: frame, spinner: UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium))
        
        self.action = action
        addSubview(spinner)
        spinner.center = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        spinner.layoutIfNeeded()
    }

    convenience init(action: @escaping (() -> Void), frame: CGRect, spinner: UIActivityIndicatorView) {
        var bounds = frame
        bounds.origin.y = 0
        spinner.bounds = bounds
        self.init(frame: frame, spinner: spinner)
        self.action = action
    }

    public init(frame: CGRect, spinner: UIActivityIndicatorView) {
        self.height = frame.height
        self.spinner = spinner
        super.init(frame: frame)
        self.autoresizingMask = .flexibleWidth
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if newSuperview == nil {
            removeKeyValueObervation()
        } else {
            guard newSuperview is UIScrollView else { return }
            
            tableView = newSuperview as? UITableView
            tableView.alwaysBounceVertical = true
            
            addKeyValueObservations()
        }
    }
    
    func setSpinerBackground(_ color: UIColor) {
        spinner.backgroundColor = color
    }
    
    deinit {
        print("LoadMoreView deinit")
        //removeKeyValueObervation()
    }
}

extension LoadMoreView {
    
    private func startAnimating() {
        spinner.isHidden = false
        spinner.startAnimating()
        self.action()
    }
    
    private func stopAnimating() {
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    
    private func addKeyValueObservations() {
        contentOffsetObservation = tableView.observe(\.contentOffset) { [weak self] scrollView, _ in
            self?.handleContentOffsetChange()
        }
        
        contentSizeObservation = tableView.observe(\.contentSize) { [weak self] scrollView, _ in
            self?.handleContentSizeChange()
        }
    }
    
    private func removeKeyValueObervation() {
        contentOffsetObservation?.invalidate()
        contentSizeObservation?.invalidate()
        
        contentOffsetObservation = nil
        contentSizeObservation = nil
    }
    
    private func handleContentOffsetChange() {
        if isLoading || !isEnabled || tableView.refreshControl?.isRefreshing ?? false {
            print("Is Loading:\(isLoading)")
            return
            
        }
        
        if tableView.contentSize.height > 0, tableView.contentOffset.y > tableView.contentSize.height - tableView.bounds.height + tableView.contentInset.bottom {
            isLoading = true
        }
    }
    
    private func handleContentSizeChange() {
        frame = CGRect(x: 0, y: tableView.contentSize.height, width: frame.size.width, height: frame.size.height)
    }
}
