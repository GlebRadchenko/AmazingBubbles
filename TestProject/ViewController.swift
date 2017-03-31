//
//  ViewController.swift
//  TestProject
//
//  Created by GlebRadchenko on 3/31/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import UIKit
import AmazingBubbles

class ViewController: UIViewController {

    @IBOutlet weak var bubblesView: ContentBubblesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bubblesView.delegate = self
        bubblesView.dataSource = self
        bubblesView.reload(randomizePosition: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ContentBubblesViewDelegate {
    func contentBubblesView(_ view: ContentBubblesView, didSelectItemAt index: Int) {
        if let labelView = view.bubbleViews[index] as? LabelBubbleView {
            labelView.imageView.isHidden = labelView.currentSize == 3
            labelView.label.isHidden = labelView.currentSize != 3
            labelView.label.text = "Hello, \(index)"
        }
    }
}

extension ViewController: ContentBubblesViewDataSource {
    func countOfSizes(in view: ContentBubblesView) -> Int {
        return 3
    }
    
    func numberOfItems(in view: ContentBubblesView) -> Int {
        return 15
    }
    
    func addOrUpdateBubbleView(forItemAt index: Int, currentView: BubbleView?) -> BubbleView {
        var view: BubbleView! = currentView
        
        if view == nil {
            if let labelView = UINib(nibName: "LabelBubbleView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LabelBubbleView {
                labelView.label.text = "Hello!"
                view = labelView
            }
        }
        
        view.backgroundColor = .clear
        let randomOrigin = CGPoint(x: CGFloat(drand48() * Double(self.view.frame.width * 2 / 3)),
                                   y: CGFloat(drand48() * Double(self.view.frame.height * 2 / 3)))
            
        view.frame = CGRect(origin: randomOrigin,
                            size: .zero)
        return view
    }
}
