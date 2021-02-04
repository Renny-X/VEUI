//
//  VELabel.h
//  VEUI
//
//  Created by Coder on 2021/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VELabelTextVerticalAlignment) {
    VELabelTextVerticalAlignmentDefault = 0,
    VELabelTextVerticalAlignmentTop,
    VELabelTextVerticalAlignmentBottom,
};

@interface VELabel : UILabel

/**
 * edgeInsets: Label四边距
 */
@property (nonatomic, assign)UIEdgeInsets edgeInsets;
/**
 * suggestWidth: Label建议宽度，不改变frame
 */
@property (nonatomic, assign, readonly)CGFloat suggestWidth;
/**
 * verticalAligment: Label的垂直对齐方式，默认垂直居中
 */
@property (nonatomic, assign)VELabelTextVerticalAlignment textVerticalAlignment;

@end

NS_ASSUME_NONNULL_END
