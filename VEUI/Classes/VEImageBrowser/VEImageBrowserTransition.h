//
//  VEImageBrowserTransition.h
//  VEUI
//
//  Created by Coder on 2021/3/3.
//

#import <Foundation/Foundation.h>
#import "VEImageBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEImageBrowserTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign)BOOL isEnter;

@property(nonatomic, strong)VEImageBrowser *target;

@end

NS_ASSUME_NONNULL_END
