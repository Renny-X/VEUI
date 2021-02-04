//
//  VEBubbleView.h
//  Store
//
//  Created by Coder on 2021/1/12.
//  Copyright © 2021 Vedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VEBubbleContentPosition) {
    VEBubbleContentPositionTop = 0, // 内容区域在上面 箭头在下面
    VEBubbleContentPositionLeft,
    VEBubbleContentPositionBottom,
    VEBubbleContentPositionRight,
};

@interface VEBubbleView : UIView

/**
 * contentBackgroundColor: 内容区域背景色
 */
@property(nonatomic, assign)UIColor *contentColor;
/**
 * cornerRadius: contentView圆角弧度，默认为5
 */
@property(nonatomic, assign)CGFloat cornerRadius;
/**
 * direction: 内容方向
 */
@property(nonatomic, assign)VEBubbleContentPosition position;
/**
 * arrowOffset:     箭头位置偏移量、相对focusView中间点 往右下为正向的偏移距离
 */
@property(nonatomic, assign)CGPoint arrowOffset;
/**
 * arrowSize:     箭头大小，arrowSize.width: 箭头底边边长，arrowSize.height: 箭头高度 默认(width: 15, height: 6)
 */
@property(nonatomic, assign)CGSize arrowSize;

@end

NS_ASSUME_NONNULL_END
