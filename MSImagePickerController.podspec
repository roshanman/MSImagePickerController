Pod::Spec.new do |s|
  s.name          = "MSImagePickerController"
  s.version       = "1.0.0"
  s.summary       = "A subclass of UIImagePickerController that support multi image select."
  s.homepage      = "https://github.com/Jameson-zxm/MSImagePickerController"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "Jameson-zxm" => "morenotepad@163.com" }
  s.platform      = :ios, '7.0'
  s.source        = { :git => "https://github.com/Jameson-zxm/MSImagePickerController", :tag => "v#{s.version}" }
  s.source_files  = 'MSImagePickerController', 'MSImagePickerController/**/*.{h,m}'
  s.resources     = "MSImagePickerController/Resources/MSImagePickerController.bundle"
  s.requires_arc  = true
  s.framework     = "UIKit"
end
