//
//  VEImageBrowserTransition.m
//  VEUI
//
//  Created by Coder on 2021/3/3.
//

#import "VEImageBrowserTransition.h"
#import "VEImageBrowserModel.h"
#import "UIColor+VEUI.h"

@implementation VEImageBrowserTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self.target setSubViewHidden:YES];
    __block CGRect fromRect, toRect;
    __block CGFloat imgVFromAlpha, imgVToAlpha, vcFromAlpha, vcToAlpha;
    
    UIView * containerView = [transitionContext containerView];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    VEImageBrowserModel *model = [self.target.imgModelArr objectAtIndex:self.target.banner.banner.selectIndex];
    
    if (self.isEnter) {
        [containerView addSubview:toViewController.view];
    }
    __block UIImageView *imgV = [self getImamgeViewWithModel:model onFull:!self.isEnter];
    if (self.isEnter) {
        fromRect = model.exitFrame;
        toRect = model.enterFrame;
        imgVFromAlpha = CGRectEqualToRect(model.originFrame, CGRectZero) ? 0.0 : 1.0;
        imgVToAlpha = 1.0;
        vcFromAlpha = 0;
        vcToAlpha = 1.0;
    } else {
        fromRect = CGRectEqualToRect(self.target.contentFrame, CGRectZero) ? model.enterFrame : self.target.contentFrame;
        toRect = CGRectEqualToRect(model.originFrame, CGRectZero) ? (CGRectEqualToRect(self.target.contentFrame, CGRectZero) ? model.exitFrame : self.target.contentFrame) : model.exitFrame;
        imgVFromAlpha = self.target.view.alpha;
        imgVToAlpha = CGRectEqualToRect(model.originFrame, CGRectZero) ? 0.0 : 1.0;
        vcFromAlpha = self.target.view.backgroundColor.alpha;
        vcToAlpha = 0.0;
    }
    
    imgV.frame = fromRect;
    imgV.alpha = imgVFromAlpha;
    self.target.view.backgroundColor = [self.target.view.backgroundColor colorWithAlphaComponent:vcFromAlpha];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        __strong typeof(self) ss = ws;
        imgV.frame = toRect;
        imgV.alpha = imgVToAlpha;
        ss.target.view.backgroundColor = [ss.target.view.backgroundColor colorWithAlphaComponent:vcToAlpha];
    } completion:^(BOOL finished) {
        __strong typeof(self) ss = ws;
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
            [imgV removeFromSuperview];
            [ss.target setSubViewHidden:NO];
        }
    }];
}

- (UIImageView *)getImamgeViewWithModel:(VEImageBrowserModel *)model onFull:(BOOL)full {
    UIImageView *imgV = [[UIImageView alloc] initWithImage:model.image];
    imgV.frame = full ? [model enterFrame] : [model exitFrame];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.clipsToBounds = YES;
    [self.target.view addSubview:imgV];
    return imgV;
}

@end
