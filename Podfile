platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

target 'test 14' do
	pod 'ServetureFramework', :path => 'app-framework-ios'
	pod 'PayHoursFramework', :path => 'paystub-ios'
	pod 'Firebase/Analytics', '~> 8.12.0'
	pod 'Firebase/Crashlytics', '~> 8.12.0'
	pod 'FirebaseDynamicLinks', '~> 8.12.0'
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
			config.build_settings['SWIFT_VERSION'] = '5.0'
		end
		# Fix bundle targets' 'Signing Certificate' to 'Sign to Run Locally'
		if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
			target.build_configurations.each do |config|
				# config.build_settings['CODE_SIGN_IDENTITY[sdk=macosx*]'] = '-'
				config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
			end
		end
	end
end
