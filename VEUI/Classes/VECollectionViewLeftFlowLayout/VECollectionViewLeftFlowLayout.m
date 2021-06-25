//
//  VECollectionViewLeftFlowLayout.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/6/25.
//

#import "VECollectionViewLeftFlowLayout.h"
#import "UIView+VEUI.h"
#import "NSArray+VEUI.h"

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
        if (i != attrsArray.count - 1) {
            UICollectionViewLayoutAttributes *curAttr = [attrsArray objectAtIndex:i];
            UICollectionViewLayoutAttributes *nextAttr = [attrsArray objectAtIndex:i + 1];
            if (curAttr.frame.origin.y == nextAttr.frame.origin.y) {
                if (nextAttr.frame.origin.x - curAttr.frame.origin.x - curAttr.frame.size.width > self.minimumInteritemSpacing) {
                    CGRect frame = nextAttr.frame;
                    CGFloat x = curAttr.frame.origin.x + curAttr.frame.size.width + self.minimumInteritemSpacing;
                    frame.origin.x = x;
                    nextAttr.frame = frame;
                }
            }
        }
    }
    return attrsArray;
}

@end
