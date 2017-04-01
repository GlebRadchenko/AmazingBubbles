Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "AmazingBubbles"
s.summary = "Nice Bubble pickers inspired by Apple"
s.requires_arc = true

# 2
s.version = "1.0.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Gleb Radchenko" => "hlib.radchenko@nure.ua" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/GlebRadchenko/AmazingBubbles"

# For example,
# s.homepage = "https://github.com/JRG-Developer/RWPickFlavor"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/GlebRadchenko/AmazingBubbles.git", :tag => "#{s.version}"}

# For example,
# s.source = { :git => "https://github.com/JRG-Developer/RWPickFlavor.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"

# 8
s.source_files = "AmazingBubbles/**/*.{swift}"

# 9
#s.resources = "AmazingBubbles/**/*.{png,gif,storyboard,xib}"
end
