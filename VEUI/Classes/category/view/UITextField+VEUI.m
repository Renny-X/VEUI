//
//  UITextField+Category.m
//  Vedeng
//
//  Created by Coder on 2020/12/3.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "UITextField+VEUI.h"
#import <objc/runtime.h>

static NSString *maxLenKey = @"maxLenKey";

@implementation UITextField (VEUI)

- (void)setMaxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, &maxLenKey, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self removeTarget:self action:@selector(onChangeText:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(onChangeText:) forControlEvents:UIControlEventEditingChanged];
}

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, &maxLenKey) integerValue];
}

- (void)onChangeText:(UITextField *)tf {
    if (self.maxLength > 0 && tf.text.length >= self.maxLength) {
        NSRange range = NSMakeRange(0, self.maxLength);
        NSString *tmpStr = tf.text;
        tmpStr = [tmpStr substringWithRange:range];
        tf.text = tmpStr;
    }
}

@end
