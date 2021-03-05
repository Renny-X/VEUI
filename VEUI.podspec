#
# Be sure to run `pod lib lint VEUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VEUI'
  s.version          = '0.1.4'
  s.summary          = 'VEUI 组件库'
  s.homepage         = 'http://gitlab.ivedeng.com/veui/veui.ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Coder' => 'it8359@vedeng.com', 'Drake' => 'it8360@vedeng.com' }
  s.source           = { :git => 'http://gitlab.ivedeng.com/veui/veui.ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'VEUI/Classes/**/*'
  s.resource_bundles = {
    'VEUI' => ['VEUI/Assets/imgs/**/*.png', 'VEUI/Assets/imgs/*.png', 'VEUI/Assets/*.ttf']
  }
  s.dependency 'Masonry', '~> 1.1.0'
end
