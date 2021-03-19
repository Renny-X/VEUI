# VEUI

[![CI Status](https://img.shields.io/travis/Coder/VEUI.svg?style=flat)](https://travis-ci.org/Coder/VEUI)
[![Version](https://img.shields.io/cocoapods/v/VEUI.svg?style=flat)](https://cocoapods.org/pods/VEUI)
[![License](https://img.shields.io/cocoapods/l/VEUI.svg?style=flat)](https://cocoapods.org/pods/VEUI)
[![Platform](https://img.shields.io/cocoapods/p/VEUI.svg?style=flat)](https://cocoapods.org/pods/VEUI)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

VEUI is available through [VDPod](http://gitlab.ivedeng.com/veui/vdpod). To install it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'http://gitlab.ivedeng.com/veui/vdpod.git'

pod 'VEUI'
```

## Author

Drake, it8360@vedeng.com<br>
Coder, it8359@vedeng.com

## License

VEUI is available under the MIT license. See the LICENSE file for more info.

## Update
```ruby
pod repo push --allow-warnings ivedeng-veui-vdpod VEUI.podspec
```

## Release Note

### 0.1.11
#### fix
* VETab 左右滑动

### 0.1.10
* VETab 支持content 左右滑动
* VETab scrollEnabled处理

### 0.1.9
#### fix
* VEToast 修复偶现不隐藏问题

### 0.1.8
#### feature
* 添加 VENoticeBar 组件
* 添加 VETab 组件
* 添加 VEModel 基类 支持嵌套解析

#### fix
* VEToast 修复偶现不隐藏问题
* UIimage VEUI 扩展方法 从View生成Image方法优化
* VEBubbleView 修复设置contentColor 导致闪退的问题

### 0.1.7
* 添加 VEPopover 组件
* 优化 UIView 扩展类方法

### 0.1.6
* 修复 UIColor 扩展hexString 方法，兼容大小写16进制色值

### 0.1.4
* 添加部分扩展类方法

### 0.1.3
* 代码修复 优化
* add VEBanner
* add VEImageBrowser 全屏图片浏览
* add 添加UIImage扩展方法 UIView导出UIImage

### 0.1.2
* 代码修复 优化
* add 添加HC字体引用到UIFont 扩展
* add VEToast

### 0.1.1
* add 添加扩展类方法
* add VEBubbleView
* add VETipView
* add VELabel
* add 城市选中 tag组件

### 0.1.0
* 测试发布
