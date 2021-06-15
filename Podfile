# platform :ios, '9.0'
inhibit_all_warnings!

target 'Github' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'

  # Rx
  pod 'RxTexture2', '~> 1.3.0'
  pod 'RxDataSources-Texture'

  # Network
  pod 'Alamofire', '~> 5.4.1'
  pod 'Moya', '~> 14.0'

  # Misc
  pod 'Swinject'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'Then'

  # Pods for Github-App

  target 'GithubTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end

  target 'GithubUITests' do
    # Pods for testing
  end
end