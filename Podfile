# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SysVPN (iOS)' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SysVPN (iOS)
  pod 'Alamofire'
  pod 'SwiftDate'
  pod 'Moya/RxSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftyJSON'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'ExytePopupView'
  pod 'SwiftGen', '~> 6.0'
end

target 'OpenVPN' do
  use_frameworks!
end

target 'WireGuard' do
  use_frameworks!
end

target 'SysVPN (macOS)' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SysVPN (macOS)

end

post_install do |installer|
   installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
         config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
end
