//
//  ContentBubblesView.swift
//  AmazingBubbles
//
//  Created by GlebRadchenko on 3/31/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import UIKit

open class ContentBubblesView: UIView {
    
    @IBOutlet public weak var delegate: ContentBubblesViewDelegate?
    @IBOutlet public weak var dataSource: ContentBubblesViewDataSource?
    
    open lazy var dynamicAnimator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self)
    }()
    
    open lazy var dynamicItemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.allowsRotation = false
        itemBehavior.density = 3
        itemBehavior.resistance = 0.4
        itemBehavior.friction = 0
        itemBehavior.elasticity = 0
        return itemBehavior
    }()
    
    open lazy var gravityBehavior: UIFieldBehavior = {
        let radialGravity: UIFieldBehavior = UIFieldBehavior.radialGravityField(position: self.center)
        radialGravity.region = UIRegion(radius: self.bounds.height * 5)
        radialGravity.minimumRadius = self.bounds.height * 5
        radialGravity.strength = BubbleConstants.initialGravityStrength
        radialGravity.animationSpeed = 1
        radialGravity.falloff = 0.1
        return radialGravity
    }()
    
    open lazy var collisionBehavior: UICollisionBehavior = {
        let collision = UICollisionBehavior()
        collision.collisionMode = UICollisionBehaviorMode.everything
        return collision
    }()
    
    open lazy var pushGravityBehavior: UIFieldBehavior = {
        let radialGravity: UIFieldBehavior = UIFieldBehavior.radialGravityField(position: self.center)
        radialGravity.region = UIRegion(radius: self.bounds.height * 5)
        radialGravity.minimumRadius = self.bounds.height * 5
        radialGravity.strength = -BubbleConstants.pushGravityStrength
        radialGravity.animationSpeed = 4
        radialGravity.falloff = 0.1
        return radialGravity
    }()
    
    
    open lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.addGestureRecognizer(pan)
        return pan
    }()
    
    open override var center: CGPoint {
        didSet {
            gravityBehavior.position = center
        }
    }
    
    open var tapEnabled: Bool = true {
        didSet {
            updateTapState()
        }
    }
    
    open var panEnabled: Bool = true {
        didSet {
            updatePanState()
        }
    }
    
    open lazy var minimalSizeForItem: CGSize = BubbleConstants.minimalSizeForItem
    open lazy var maximumSizeForItem: CGSize = BubbleConstants.maximumSizeForItem
    open lazy var countOfSizes: Int = 3
    
    open var bubbleViews: [BubbleView] = []
    
    public init() {
        super.init(frame: .zero)
        initialSetup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if dynamicAnimator.behaviors.isEmpty {
            initialSetup()
        }
    }
    
    func initialSetup() {
        addBehaviors()
        updatePanState()
        updateTapState()
    }
        
    open func addBehaviors() {
        [dynamicItemBehavior,
         gravityBehavior,
         collisionBehavior,
         pushGravityBehavior].forEach { dynamicAnimator.addBehavior($0) }
    }
    
    open func reload(randomizePosition: Bool = false) {
        guard let dataSource = dataSource else {
            removeViewsFromBehaviors()
            removeViews()
            return
        }
        countOfSizes = dataSource.countOfSizes?(in: self) ?? 3
        minimalSizeForItem = delegate?.minimalSizeForBubble?(in: self) ?? BubbleConstants.minimalSizeForItem
        maximumSizeForItem = delegate?.maximumSizeForBubble?(in: self) ?? BubbleConstants.maximumSizeForItem
        
        let countOfItems = dataSource.numberOfItems(in: self)
        removeOddViews(for: countOfItems)
        addOrReloadNeededViews(for: countOfItems)
        
        updatePanState()
        updateTapState()
        
        if randomizePosition {
            self.randomizePosition()
        }
        bubbleViews.forEach { $0.layoutIfNeeded() }
    }
}

//MARK: - Items positioning and sizes
extension ContentBubblesView {
    func calculateSize(for size: Int) -> CGSize {
        assert(size > 0, "Size must be greater than or equal 1")
        
        let maxW = maximumSizeForItem.width
        let maxH = maximumSizeForItem.height
        
        let minW = minimalSizeForItem.width
        let minH = minimalSizeForItem.height
        
        let multiplier = CGFloat(size) / CGFloat(countOfSizes)
        
        let calculatedWidth = minW + (maxW - minW) * multiplier
        let calculatedHeight = minH + (maxH - minH) * multiplier
        
        return CGSize(width: calculatedWidth,
                      height: calculatedHeight)
    }
    
    func randomizeSize() {
        bubbleViews.forEach { (view) in
            let randomSize = Int(arc4random_uniform(UInt32(countOfSizes))) % countOfSizes + 1
            let size = calculateSize(for: randomSize)
            view.frame = CGRect(origin: view.frame.origin,
                                size: size)
        }
    }
    
    func randomizePosition() {
        if bubbleViews.count == 1 {
            let position = randomPosition(for: .center)
            bubbleViews[0].frame.origin = position
            return
        }
        
        let leftBubbles = bubbleViews[0..<bubbleViews.count / 2]
        let rightBubbles = bubbleViews[bubbleViews.count / 2..<bubbleViews.count]
        
        leftBubbles.forEach { (view) in
            let position = randomPosition(for: .left)
            view.frame.origin = position
        }
        
        rightBubbles.forEach { (view) in
            let position = randomPosition(for: .right)
            view.frame.origin = position
        }
    }
    
    enum BubblePosition {
        case left, right, center
    }
    
    func randomPosition(for position: BubblePosition) -> CGPoint {
        let xRand = drand48()
        let yRand = drand48()
        
        let deltaRandY = yRand - drand48()
        switch position {
        case .center:
            let deltaRandX = xRand - drand48()
            return CGPoint(x: Double(center.x) + deltaRandX * 50,
                           y: Double(center.y) + deltaRandY * 50)
        case .left:
            return CGPoint(x: Double(frame.origin.x) - xRand * Double(bounds.width),
                           y: Double(center.y) + deltaRandY * Double(bounds.height / 2))
        case .right:
            return CGPoint(x: Double(frame.origin.x + frame.width) + xRand * Double(bounds.width),
                           y: Double(center.y) + deltaRandY * Double(bounds.height / 2))
        }
    }
}

//MARK: - Items processing

extension ContentBubblesView {
    
    internal func addOrReloadNeededViews(for count: Int) {
        guard let dataSource = dataSource else {
            fatalError("No dataSource for content view")
        }
        
        (0..<count).forEach { (index) in
            let currentView: BubbleView? = index < bubbleViews.count
                ? bubbleViews[index]
                : nil
            
            let bubbleView = dataSource.addOrUpdateBubbleView(forItemAt: index, currentView: currentView)
            
            if bubbleView.frame.size == .zero {
                let newSize = calculateSize(for: bubbleView.currentSize)
                let currentOrigin = bubbleView.frame.origin
                
                bubbleView.frame = CGRect(origin: currentOrigin,
                                          size: newSize)
            }
            
            addIfNeeded(bubbleView)
            
            if !bubbleViews.contains(bubbleView) {
                bubbleViews.append(bubbleView)
            }
        }
    }
    
    internal func addIfNeeded(_ item: BubbleView) {
        if item.superview == nil {
            addSubview(item)
        }
        
        dynamicItemBehavior.addItem(item)
        gravityBehavior.addItem(item)
        collisionBehavior.addItem(item)
        
        if item.tapGestureRecognizer == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            item.addGestureRecognizer(tap)
            item.tapGestureRecognizer = tap
        }
    }
    
    internal func removeOddViews(for count: Int) {
        if count >= bubbleViews.count { return }
        let countToDelete = count - bubbleViews.count
        
        (1...countToDelete).forEach { (_) in
            let viewToRemove = bubbleViews.removeLast()
            removeBehaviors(for: viewToRemove)
            viewToRemove.removeFromSuperview()
        }
    }
    
    internal func removeBehaviors(for view: BubbleView) {
        dynamicItemBehavior.removeItem(view)
        gravityBehavior.removeItem(view)
        collisionBehavior.removeItem(view)
        pushGravityBehavior.removeItem(view)
    }
    
    internal func removeViewsFromBehaviors() {
        bubbleViews.forEach {
            removeBehaviors(for: $0)
        }
    }
    
    internal func removeViews() {
        bubbleViews.forEach { $0.removeFromSuperview() }
        bubbleViews.removeAll()
    }
}

//MARK: - Gestures handling

public extension ContentBubblesView {
    
    internal func updatePanState() {
        panGestureRecognizer.isEnabled = panEnabled
    }
    
    internal func updateTapState() {
        bubbleViews.forEach{ $0.tapGestureRecognizer?.isEnabled = tapEnabled }
    }
    
    public func handlePan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            gravityBehavior.position = pan.location(in: self)
            gravityBehavior.strength = BubbleConstants.panGravityStrength
            dynamicItemBehavior.density = 1
        case .changed:
            gravityBehavior.position = pan.location(in: self)
        default:
            gravityBehavior.position = center
            gravityBehavior.strength = BubbleConstants.initialGravityStrength
            dynamicItemBehavior.density = 7
        }
    }
    
    public func handleTap(_ tap: UITapGestureRecognizer) {
        guard let bubbleView = tap.view as? BubbleView else {
            return
        }
        
        guard let index = bubbleViews.index(of: bubbleView) else {
            fatalError("No such bubbleView in content View")
        }
        
        delegate?.contentBubblesView?(self, didSelectItemAt: index)
        let shouldChangeSize = delegate?.contentBubblesView?(self, shouldChangeSizeForItemAt: index) ?? true
        if !shouldChangeSize {
            return
        }
        
        changeSize(for: bubbleView) { [weak self] in
            guard let wSelf = self else { return }
            wSelf.delegate?.contentBubblesView?(wSelf, didChangeSizeForItemAt: index)
        }
    }
    
    internal func changeSize(for view: BubbleView, completion: @escaping () -> Void) {
        let oldSize = view.bounds.size
        view.currentSize = view.currentSize % countOfSizes + 1
        let newSize = calculateSize(for: view.currentSize)
        
        let deltaW = newSize.width - oldSize.width
        let deltaH = newSize.height - oldSize.height
        
        //set push gravityBehavior position if needed
        let viewsToPush = bubbleViews.filter { $0 != view }
        
        if view.currentSize > 1 {
            pushGravityBehavior.position = view.center
            pushGravityBehavior.region = UIRegion(radius: view.bounds.width * 3)
            viewsToPush.forEach { pushGravityBehavior.addItem($0) }
        }
        
        bubbleViews.forEach { gravityBehavior.removeItem($0) }
        //resize size of item after push
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            viewsToPush.forEach { self.pushGravityBehavior.removeItem($0) }
            self.removeBehaviors(for: view)
            let newOrigin = CGPoint(x: view.frame.origin.x - deltaW / 2,
                                    y: view.frame.origin.y - deltaH / 2)
            
            UIView.animate(withDuration: BubbleConstants.growAnimationDuration, animations: {
                view.frame = CGRect(origin:newOrigin,
                                    size: newSize)
                view.layoutSubviews()
                
            }, completion: { (_) in
                self.bubbleViews.forEach { self.gravityBehavior.addItem($0) }
                self.dynamicItemBehavior.addItem(view)
                self.collisionBehavior.addItem(view)
                completion()
            })
        }
    }
}
