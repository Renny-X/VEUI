//
//  UIView+VEUI.m
//  Store
//
//  Created by Coder on 2021/1/12.
//  Copyright © 2021 Vedeng. All rights reserved.
//

#import "UIView+VEUI.h"

@implementation UIView (VEUI)

- (UIViewController *)viewController {
    for(UIView *next = self.superview; next; next = next.superview){
        UIResponder *nextResponder = [next nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (id)concat {
    NSData *tmpData = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tmpData];
}

@end
