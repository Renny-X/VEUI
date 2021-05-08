//
//  VETabContentCollectionView.m
//  VEUI
//
//  Created by Coder on 2021/5/8.
//

#import "VETabContentCollectionView.h"

@implementation VETabContentCollectionView

+ (instancetype)contentView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionHeadersPinToVisibleBounds = NO;
    layout.sectionFootersPinToVisibleBounds = NO;
    layout.minimumLineSpacing = CGFLOAT_MIN;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    
    VETabContentCollectionView *colV = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    colV.bounces = NO;
    colV.pagingEnabled = YES;
    colV.showsVerticalScrollIndicator = NO;
    colV.showsHorizontalScrollIndicator = NO;
    colV.backgroundColor = [UIColor clearColor];
    return colV;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 是否为平移手势
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        // 获取平移方向
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
        // 向右滑动 && scrollView滑动到最左侧
        if (translation.x >= 0 && self.contentOffset.x <= 0) {
            return NO;
        }
    }
    return YES;
}

@end
