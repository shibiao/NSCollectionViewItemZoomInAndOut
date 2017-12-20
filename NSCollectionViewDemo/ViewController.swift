//
//  ViewController.swift
//  NSCollectionViewDemo
//
//  Created by sycf_ios on 2017/12/15.
//  Copyright © 2017年 sycf_ios. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    static let itemIdentifier = "UserItem"
    let layout = NSCollectionViewFlowLayout()
    lazy var transitionItem = { () -> CustomImageButton in
        let button = CustomImageButton()
        button.imageScaling = .scaleProportionallyUpOrDown
        button.target = self
        button.action = #selector(handleButtonClick(_:))
        return button
    }()
    var rect: NSRect?
    @IBOutlet weak var collectionView: NSCollectionView!
    var flag: Bool = false
    var data = Array<Any>()
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let tmpNib = NSNib(nibNamed: NSNib.Name(rawValue: "UserItem"), bundle: nil) else {return}
        
        collectionView.register(NSNib(nibNamed: NSNib.Name.init("UserItem"), bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(ViewController.itemIdentifier))
        
        layout.itemSize = NSMakeSize(40, 40)
        collectionView.collectionViewLayout = layout
        
        data = [
            "1",
            "2",
            "1",
            "2",
            ]
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @objc func handleButtonClick(_ sender: NSButton) {
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.5
            context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            self.transitionItem.animator().frame = rect!
            
        }, completionHandler: {
            self.collectionView.isHidden = false
            self.transitionItem.removeFromSuperview()
        })
        
        
    }

}
extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: ViewController.itemIdentifier), for: indexPath) as! UserItem
        item.handleCallUser { (button) in
            print(indexPath.item)
            self.refreshItem(item, at: indexPath)
        }
        item.userAvatar.image = NSImage(named: NSImage.Name.init(data[indexPath.item] as! String))
        return item
    }
    func refreshItem(_ item: UserItem, at indexPath: IndexPath) {
        
//        flag = !flag
//        rect = item.view.frame
        
        rect = self.view.convert(item.view.frame, from: self.collectionView)
        self.transitionItem.frame = rect!
//        if let image = item.userAvatar.image {
        transitionItem.image = NSImage(named: NSImage.Name.init(data[indexPath.item] as! String))
//        }
        collectionView.isHidden = true
        self.view.addSubview(transitionItem)
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.5
            context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            self.transitionItem.animator().frame = NSMakeRect(0, 0, 300, 300)
            
        }, completionHandler: nil)

        

        
    }
    
}
