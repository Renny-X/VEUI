//
//  VECollectionSectionBackView.m
//  VEUI
//
//  Created by Coder on 2021/6/25.
//

#import "VECollectionSectionBackView.h"
#import "UIView+VEUI.h"

@implementation VECollectionSectionBackView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    self.attributes = (VECollectionViewLayoutAttributes *)layoutAttributes;
    [self changeLayout];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self changeLayout];
}

- (void)changeLayout {
    if (!self.attributes) {
        return;
    }
    UIColor *bgColor = self.attributes.backgroundColor ?: [UIColor clearColor];
    UIView *view = self;
    [view removeAllSubviews];
    
    if (self.attributes.customView) {
        bgColor = UIColor.clearColor;
    }
    if (@available(iOS 13.0, *)) {
        view.layer.backgroundColor = [bgColor resolvedColorWithTraitCollection:self.traitCollection].CGColor;
    } else {
        view.layer.backgroundColor = bgColor.CGColor;
    }
    [view addSubview:self.attributes.customView];
}

@end
