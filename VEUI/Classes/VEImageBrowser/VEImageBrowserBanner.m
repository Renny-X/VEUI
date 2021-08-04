//
//  VEImageBrowserBanner.m
//  VEUI
//
//  Created by Coder on 2021/3/3.
//

#import "VEImageBrowserBanner.h"
#import <VEUI/VEUI.h>
#import "VEImageBrowserBannerItem.h"

@interface VEImageBrowserBanner ()<VEImageBrowserBannerItemDelegate>

@end

@implementation VEImageBrowserBanner

#pragma mark - VEImageBrowserBannerItemDelegate
- (void)bannerItemOnSingleTap {
    if ([self.delegate respondsToSelector:@selector(bannerOnSingleTap)]) {
        [self.delegate bannerOnSingleTap];
    }
}

- (void)bannerItemShouldDismiss {
    if ([self.delegate respondsToSelector:@selector(bannerShouldDismiss)]) {
        [self.delegate bannerShouldDismiss];
    }
}

- (void)bannerItemShouldChangeSuperAlpha:(CGFloat)alpha inContentFrame:(CGRect)frame{
    if ([self.delegate respondsToSelector:@selector(bannerShouldChangeSuperAlpha:inContentFrame:)]) {
        [self.delegate bannerShouldChangeSuperAlpha:alpha inContentFrame:frame];
    }
}

#pragma mark - Init
- (instancetype)initWithDataSource:(NSArray<UIView *> *)dataSource {
    return [self initWithDataSource:dataSource selectIndex:0];
}

- (instancetype)initWithDataSource:(NSArray<UIView *> *)dataSource selectIndex:(NSInteger)index {
    if (self = [super init]) {
        self.frame = [UIScreen bounds];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < dataSource.count; i++) {
            UIView *view = [dataSource objectAtIndex:i];
            VEImageBrowserBannerItem *item = [[VEImageBrowserBannerItem alloc] initWithContentView:view];
            item.delegate = self;
            [arr addObject:item];
        }
        
        self.banner = [[VEImageBanner alloc] initWithFrame:self.bounds];
        self.banner.dataSource = [NSArray arrayWithArray:arr];
        self.banner.backgroundColor = [UIColor clearColor];
        [self addSubview:self.banner];
        
        self.banner.selectIndex = index;
    }
    return self;
}

#pragma mark - Factory
- (VEImageBrowserBannerItem *)itemWithView:(UIView *)view {
    VEImageBrowserBannerItem *item = [[VEImageBrowserBannerItem alloc] initWithContentView:view];
    
    return item;
}

@end
