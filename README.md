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

### 0.2.7

#### add

#### remove
* 删除 VECollectionViewLeftFlowLayout，用VECollectionViewFlowLayout itemAlignment 代替

#### upgrade
* VECollectionViewFlowLayout 支持设置 item 对齐方式设置

### 0.2.6

#### add
* UIView 添加 top、left、bottom、right 属性
* UITabBarItem 添加 badgeDot 相关属性
* UITabBarItem 添加 animateImages: duration: 方法
* VETabBarController 添加 lastSelectedIndex 属性
* NSObject KVO 安全添加KVO监听，避免重复添加
* VECollectionViewFlowLayout 支持设置 section 背景色
* VECollectionViewLeftFlowLayout collectionView 左对齐
* UIAlertAction 添加颜色扩展
* UIImage 添加 设置图片颜色 返回指定像素点颜色 高斯模糊 重绘边距等方法
* NSDate 添加时间戳方法

#### upgrade
* VEBanner 交互优化，支持无限滚动，自动轮播
* VEPopover 交互优化，添加动画入口
* VENoticeBar 优化自定义入口
* VEToast 优化自定义入口

### 0.2.5

#### add
* UITextView 添加 maxLength 属性
#### upgrade
* 更新 VEFont 字体文件
* 更新 VEToast 样式

### 0.2.4
#### upgrade
* 升级VEToast 支持VEToast 始终保持在最上层

### 0.2.3
#### upgrade
* 升级 VETab 支持左滑返回手势

### 0.2.2
#### add
* 扩展多个 safe 取值方法

#### upgrade
* 升级 VETab 组件

### 0.2.0
#### add
* 添加 NSString 是否包含中文 实例方法

#### upgrade
* 更新 UIColor colorWithHexString 方法，使用 P3Color
* VEpopover 修复点击收起功能、添加背景色设置入口

### 0.1.18
#### upgrade
* 更新 VEFont 字体文件

### 0.1.17
#### upgrade
* VEToast 优化代码结构 优化toast交互

### 0.1.16
#### upgrade
* VEToast 优化代码结构 修改toast mask时交互效果

### 0.1.15
#### upgrade
* VETab 添加强制刷新数据方法 处理刷新数据不生效的问题

### 0.1.14
#### upgrade
* VETab支持滑动 + 点击切换，支持主动调用方法切换

### 0.1.13
#### add
* UIColor 添加随机颜色方法
* UIColor 添加两种颜色 取任意中间颜色 的方法

#### upgrade
* VETab 升级滚动样式

### 0.1.12
#### fix
* VETab 适配13.5系统 点击collectionViewCell后需要手动更新UI

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
