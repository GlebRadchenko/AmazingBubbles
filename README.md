# AmazingBubbles
Bubble pickers, inspired by Apple

![](https://github.com/GlebRadchenko/AmazingBubbles/blob/master/Resources/example.gif)

## Requirements: 
  - iOS 9.1+
  - XCode 8.0+ 
  - Swift 3.0
  
## Installation
AmazingBubbles Library is available through [CocoPods](https://cocoapods.org). To install, add the following line to your Podfile: 

  ``` ruby
  pod 'AmazingBubbles', '~> 0.0'
```

## Usage: 

 1. Import library as follows: 
 
  ``` swift
  import AmazingBubbles
```

 2. Add ContentBubblesView to your VC;
 3. Add delegate and dataSource for ContentBubblesView instance:
 
  ``` swift
class ViewController: UIViewController {

    @IBOutlet weak var bubblesView: ContentBubblesView! {
        didSet {
            bubblesView.delegate = self
            bubblesView.dataSource = self
        }
    }
    
}
```

 4. Implement protocols :
``` swift
public protocol ContentBubblesViewDelegate: class {
    func minimalSizeForBubble(in view: ContentBubblesView) -> CGSize
    func maximumSizeForBubble(in view: ContentBubblesView) -> CGSize
    
    func contentBubblesView(_ view: ContentBubblesView, didSelectItemAt index: Int)
    func contentBubblesView(_ view: ContentBubblesView, shouldChangeSizeForItemAt index: Int) -> Bool
    func contentBubblesView(_ view: ContentBubblesView, didChangeSizeForItemAt index: Int)
}

public protocol ContentBubblesViewDataSource: class {
    func countOfSizes(in view: ContentBubblesView) -> Int
    
    func numberOfItems(in view: ContentBubblesView) -> Int
    func addOrUpdateBubbleView(forItemAt index: Int, currentView: BubbleView?) -> BubbleView
}
```
for example: 
``` swift
extension ViewController: ContentBubblesViewDataSource {
    func countOfSizes(in view: ContentBubblesView) -> Int {
        return 3
    }
    
    func numberOfItems(in view: ContentBubblesView) -> Int {
        return 15
    }
    
    func addOrUpdateBubbleView(forItemAt index: Int, currentView: BubbleView?) -> BubbleView {
        var view: BubbleView = currentView ?? BubbleView()        
        view.backgroundColor = .clear
        let randomOrigin = CGPoint(x: CGFloat(drand48() * Double(self.view.frame.width * 2 / 3)),
                                   y: CGFloat(drand48() * Double(self.view.frame.height * 2 / 3)))
        view.frame = CGRect(origin: randomOrigin,
                            size: .zero)
        return view
    }
}
 ```
 5. And than call:
 
 ``` swift
 bubblesView.reload(randomizePosition: true) 
 ```
 
 ## Additional features: 
 - You can create custom views by subclassing BubbleView
 - You can enable/disable gestures in ContentBubblesView:
 ``` swift
 bubblesView.tapEnabled = true
 bubblesView.panEnabled = false
 ```
 - Also you can change some settings in BubbleConstants struct or play with some settings of UIDynamicBehaviors.
