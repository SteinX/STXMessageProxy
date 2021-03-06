#
# Be sure to run `pod lib lint STXMessageProxy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'STXMessageProxy'
  s.version          = '0.1.1'
  s.summary          = 'A proxy to control the distribution of the message delivery of the objc based on the message forwarding mechanism.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  STXMessageProxy is an abstract tool which can help you to change the ordinary method calling behavior to the one of the following behavior:
  Broadcasting & Interception. This tool can be helpful when you'd like to keep mutiple members to be informed from one source (delegate), or
  override certain behavior of the original one without changing the source code by just intercepting the call.
                       DESC

  s.homepage         = 'https://github.com/SteinX/STXMessageProxy'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SteinX' => 'steinxia@gmail.com' }
  s.source           = { :git => 'https://github.com/SteinX/STXMessageProxy.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'STXMessageProxy/Classes/**/*.{h,m}'
  s.private_header_files = 'STXMessageProxy/Classes/Private/**/*.h'
end
