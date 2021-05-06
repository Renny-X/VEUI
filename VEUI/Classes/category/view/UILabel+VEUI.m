//
//  UILabel+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/5/6.
//

#import "UILabel+VEUI.h"

@implementation UILabel (VEUI)
/**
 * 两端对齐
 */
- (void)textAlignmentLeftAndRight {
    return [self textAlignmentLeftAndRightWith:self.frame.size.width];
}
/**
 * 指定Label以最后的冒号对齐的width两端对齐
 */
- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth {
    if(self.text == nil || self.text.length == 0) {
        return;
    }
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{
        NSFontAttributeName:self.font,
        NSForegroundColorAttributeName:self.textColor,
    } context:nil].size;
    NSInteger length = (self.text.length - 1);
    CGFloat margin = (labelWidth - size.width) / length;
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attribute addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,length)];
    self.attributedText= attribute;
}

@end
