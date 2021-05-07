//
//  VETools.h
//  VEUI
//
//  Created by Coder on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern int randomNum(int from, int to);

extern BOOL NSRangeContainRange(NSRange range, NSRange subRange);

@interface VETools : NSObject

+ (CGFloat)statusBarHeight;

@end

NS_ASSUME_NONNULL_END
