//
//  VECollectionViewLeftFlowLayout.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/6/25.
//

#import "VECollectionViewLeftFlowLayout.h"
#import "UIView+VEUI.h"
#import "NSArray+VEUI.h"
#import "VECollectionViewLayoutAttributes.h"

@implementation VECollectionViewLeftFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attrsArray = [super layoutAttributesForElementsInRect:rect];
    if (!attrsArray) {
        return nil;
    }
    for (int i = 0; i < attrsArray.count; i++) {
        UICollectionViewLayoutAttributes *curAttr = [attrsArray objectAtIndex:i];
        if ([curAttr isKindOfClass:[VECollectionViewLayoutAttributes class]]) {
            // 这个是背景色用的。
            continue;
        }
        if ([curAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] || [curAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            // 过滤 header footer
            continue;
        }
        CGFloat left = 0;
        id<UICollectionViewDelegateFlowLayout> deleget = (id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        if (deleget && [deleget respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            UIEdgeInsets insets = [deleget collectionView:self.collectionView layout:self insetForSectionAtIndex:curAttr.indexPath.section];
            left = insets.left;
        }
        CGRect frame = curAttr.frame;
        if (i == 0) {
            // 第一个 操作一下
            frame.origin.x = left;
            curAttr.frame = frame;
            continue;
        }
        UICollectionViewLayoutAttributes *lastAttr = [attrsArray objectAtIndex:i - 1];
        if (lastAttr.frame.origin.y != curAttr.frame.origin.y) {
            // 每行的第一个 操作一下
            frame.origin.x = left;
            curAttr.frame = frame;
            continue;
        }
        // 每行的非第一个
        frame.origin.x = lastAttr.frame.origin.x + lastAttr.frame.size.width + self.minimumInteritemSpacing;
        curAttr.frame = frame;
    }
    return attrsArray;
}

@end
