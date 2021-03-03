//
//  VEImageBrowserTransition.m
//  VEUI
//
//  Created by Coder on 2021/3/3.
//

#import "VEImageBrowserTransition.h"
#import "VEImageBrowserModel.h"

@implementation VEImageBrowserTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self.target setSubViewHidden:YES];
    UIView * containerView = [transitionContext containerView];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    VEImageBrowserModel *model = [self.target.imgModelArr objectAtIndex:self.target.banner.banner.selectIndex];
    
    if (self.isEnter) {
        [containerView addSubview:toViewController.view];
    }
    UIImageView *imgV = [self getImamgeViewWithModel:model onFull:!self.isEnter];
    CGFloat targetAlpha = 1.0;
    if (CGRectEqualToRect(model.originFrame, CGRectZero)) {
        imgV.alpha = self.isEnter ? 0.0 : 1.0;
        self.target.view.alpha = self.isEnter ? 0.0 : 1.0;
        targetAlpha = self.isEnter ? 1.0 : 0.0;
    }
    CGRect targetFrame = model.enterFrame;
    if (!self.isEnter) {
        imgV.alpha = self.target.view.alpha;
        imgV.frame = self.target.contentFrame;
        
        targetFrame = CGRectEqualToRect(model.originFrame, CGRectZero) ? (CGRectEqualToRect(self.target.contentFrame, CGRectZero) ? model.exitFrame : self.target.contentFrame) : model.exitFrame;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imgV.frame = targetFrame;
        imgV.alpha = targetAlpha;
        self.target.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.isEnter ? 1.0 : 0.0];
        self.target.view.alpha = targetAlpha;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
            [imgV removeFromSuperview];
            [self.target setSubViewHidden:NO];
        }
    }];
}

- (UIImageView *)getImamgeViewWithModel:(VEImageBrowserModel *)model onFull:(BOOL)full {
    UIImageView *imgV = [[UIImageView alloc] initWithImage:model.image];
    imgV.frame = full ? [model enterFrame] : [model exitFrame];
//    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.clipsToBounds = YES;
    [self.target.view addSubview:imgV];
    return imgV;
}

@end
