Pod::Spec.new do |spec|

spec.name         = "DigioUpi"
spec.version      = "0.0.1"
spec.summary      = "Digio UPI framework enables seamless integration of Unified Payments Interface (UPI) and Reverse Penny Drop functionality into your app, allowing users/corporates  to create mandate and account verification."

spec.description  = <<-DESC
Mandate creation/Recurring payments. Reverse penny drop
DESC

spec.homepage     = "https://github.com/digio-tech/ios-upi-sdk"
spec.license      = { :type => "Apache", :file => "LICENSE" }
spec.author       = { "Akash Kumar" => "akash.kumar@digio.in" }
spec.social_media_url   = "https://twitter.com/digio_in"
spec.platform     = :ios

spec.ios.deployment_target = "13.0"
spec.source       = { :git => "https://github.com/digio-tech/ios-upi-sdk.git", :tag => "#{spec.version}" }
spec.vendored_frameworks = "DigioUpi.xcframework"
end