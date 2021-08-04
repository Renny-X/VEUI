//
//  UITextView+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/6/8.
//

#import "UITextView+VEUI.h"
#import <objc/runtime.h>

//static NSString *maxLenKey = @"maxLenKey";

@implementation UITextView (VEUI)

- (void)setMaxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMaxLength) name:UITextViewTextDidChangeNotification object:nil];
}

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, @selector(maxLength)) integerValue];
}

- (void)setTextDidChange:(void (^)(void))textDidChange {
    objc_setAssociatedObject(self, @selector(textDidChange), textDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))textDidChange {
    return objc_getAssociatedObject(self, @selector(textDidChange));
}

- (void)handleMaxLength {
    if (self.textDidChange) {
        self.textDidChange();
    }
    if (self.maxLength == 0) {
        return;
    }
    if (self.text.length > self.maxLength) {
        self.text = [self.text substringWithRange:NSMakeRange(0, self.maxLength)];
    }
}

@end
