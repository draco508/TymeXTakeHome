//
//  CollapsableView.swift
//   
//
//  Created by admin on 18/03/2022.

//

import UIKit

class CollapsableView: UIStackView {
    
    enum State {
        case collapse
        case expand
        case animating
    }
    
    @IBInspectable var collapsableTag: Int = 0
    
    var didUpdateStateListener: ((State) -> Void)?
    
    private var collapsableChildView: UIView?
    
    private var state: State = .collapse
    
    private var maxHeight: CGFloat = 0
    
    func configDefaultState(_ state: State) {
        self.state = state
        if state == .collapse {
            collapse()
        } else if state == .expand {
            expand()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.collapsableTag == 0 {
            print("Can not find collapsable child view.")
        } else {
            collapsableChildView = self.viewWithTag(collapsableTag)
        }
    }
    
    func collapse() {
        
        guard let collapsableChildView = collapsableChildView else {
            return
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .transitionCrossDissolve, animations: {
            collapsableChildView.alpha = 0
            collapsableChildView.isHidden = true
        }, completion: nil)
        
        
    }
    
    func expand() {
        guard let collapsableChildView = collapsableChildView else {
            return
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .transitionCrossDissolve, animations: {
            collapsableChildView.alpha = 1
            collapsableChildView.isHidden = false
        }, completion: nil)
        
    }
    
    func toggle() {
        switch self.state {
        case .collapse:
            state = .expand
            expand()
        case .expand:
            state = .collapse
            collapse()
        case .animating:
            break
        }
    }
    
}
