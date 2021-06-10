//
//  UITextView+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/6/8.
//

#import "UITextView+VEUI.h"
#import <objc/runtime.h>

static NSString *maxLenKey = @"maxLenKey";

@implementation UITextView (VEUI)

- (void)setMaxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, &maxLenKey, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMaxLength) name:UITextViewTextDidChangeNotification object:nil];
}

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, &maxLenKey) integerValue];
}

- (void)handleMaxLength {
    if (self.maxLength == 0) {
        return;
    }
    if (self.text.length > self.maxLength) {
        self.text = [self.text substringWithRange:NSMakeRange(0, self.maxLength)];
    }
}

@end
