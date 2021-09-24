//
//  VECollectionViewFlowLayout.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/6/25.
//

#import "VECollectionViewFlowLayout.h"
#import "VECollectionViewLayoutAttributes.h"
#import "VECollectionSectionBackView.h"
#import "VEUI.h"

#define VECollectionViewSection @"VECollectionViewDelegateFlowLayout"

@interface VECollectionViewFlowLayout ()

@property(nonatomic, strong)NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end

@implementation VECollectionViewFlowLayout

#pragma mark - Override
- (void)prepareLayout {
    [super prepareLayout];
    NSInteger sections = [self.collectionView numberOfSections];
    id <VECollectionViewDelegateFlowLayout> delegate  = (id <VECollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    BOOL isBgColor = [delegate respondsToSelector:@selector(collectionView:layout:backgroundColorAtSection:)];
    BOOL isBgView = [delegate respondsToSelector:@selector(collectionView:layout:backgroundViewAtSection:sectionFrame:)];
    if (!isBgColor && !isBgView) {
        return;
    }
    [self registerClass:[VECollectionSectionBackView class] forDecorationViewOfKind:VECollectionViewSection];
    [self.decorationViewAttrs removeAllObjects];
    
    for (NSInteger section = 0; section < sections; section++) {
        CGRect sectionFrame = [self itemsAreaAtSection:section];
        
        VECollectionViewLayoutAttributes *attrs = [VECollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:VECollectionViewSection withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        attrs.frame = sectionFrame;
        attrs.zIndex = -1;
        if (isBgColor) {
            attrs.backgroundColor = [delegate collectionView:self.collectionView layout:self backgroundColorAtSection:section];
        }
        if (isBgView) {
            UIView *view = [delegate collectionView:self.collectionView layout:self backgroundViewAtSection:section sectionFrame:sectionFrame];
            attrs.customView = view;
            attrs.backgroundColor = UIColor.clearColor;
        }
        
        [self.decorationViewAttrs addObject:attrs];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attrs = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    // 这里操作一下item布局
    if (self.itemAlignment != VECollectionViewFlowLayoutAlignmentDefault) {
        
        NSMutableArray *tmpItems = [NSMutableArray array];
        for (int i = 0; i < attrs.count; i++) {
            UICollectionViewLayoutAttributes *curAttr = [attrs objectAtIndex:i];
            UIEdgeInsets insets = UIEdgeInsetsZero;
            id<UICollectionViewDelegateFlowLayout> delegate = (id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
            if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                insets = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:curAttr.indexPath.section];
            }
            if (curAttr.representedElementCategory == UICollectionElementCategoryCell) {
                // 是 cellItem 操作完过去下一轮
                if (i == 0) {
                    // 第一个 丢去待处理
                    [tmpItems addObject:curAttr];
                    continue;
                }
                
                UICollectionViewLayoutAttributes *lastAttr = [attrs objectAtIndex:i - 1];
                if (lastAttr.frame.origin.y != curAttr.frame.origin.y) {
                    // 每行的第一个 先操作完之前的item，清空 tmpItems 再往里丢新一行的item
                    if (tmpItems.count) {
                        int startIndex = self.itemAlignment == VECollectionViewFlowLayoutAlignmentLeft ? 0 : (int)tmpItems.count - 1;
                        int step = self.itemAlignment == VECollectionViewFlowLayoutAlignmentLeft ? 1 : -1;
                        for (int j = startIndex; j < tmpItems.count && j >= 0; j += step) {
                            UICollectionViewLayoutAttributes *handleCurAttr = [tmpItems objectAtIndex:j];
                            
                            CGFloat left = 0;
                            CGFloat right = 0;
                            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                                if (self.itemAlignment == VECollectionViewFlowLayoutAlignmentLeft) {
                                    left = insets.left;
                                } else {
                                    right = self.collectionView.width - insets.right;
                                }
                            } else {
                                CGRect itemsArea = [self itemsAreaAtSection:handleCurAttr.indexPath.section];
                                if (self.itemAlignment == VECollectionViewFlowLayoutAlignmentLeft) {
                                    left = itemsArea.origin.x + insets.left;
                                } else {
                                    right = CGRectGetMaxX(itemsArea) - insets.right;
                                }
                            }
                            
                            CGRect frame = handleCurAttr.frame;
                            if (j == startIndex) {
                                // 第一个 先打个样
                                if (self.itemAlignment == VECollectionViewFlowLayoutAlignmentLeft) {
                                    frame.origin.x = left;
                                } else {
                                    frame.origin.x = right - frame.size.width;
                                }
                                handleCurAttr.frame = frame;
                                continue;
                            }
                            // 操作除第一个以外的 item
                            
                            // 先搞定gap
                            CGFloat gap = 0;
                            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                                // 垂直滚动
                                gap = self.minimumInteritemSpacing;
                                if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
                                    gap = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:curAttr.indexPath.section];
                                }
                            } else {
                                // 横向滚动
                                gap = self.minimumLineSpacing;
                                if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
                                    gap = [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:curAttr.indexPath.section];
                                }
                            }
                            
                            // 再取上一个出来玩
                            UICollectionViewLayoutAttributes *handleLastAttr = [tmpItems objectAtIndex:j - step];
                            if (self.itemAlignment == VECollectionViewFlowLayoutAlignmentLeft) {
                                frame.origin.x = CGRectGetMaxX(handleLastAttr.frame) + gap;
                            } else {
                                frame.origin.x = handleLastAttr.frame.origin.x - gap - frame.size.width;
                            }
                            handleCurAttr.frame = frame;
                        }
                    }
                    // 清空 tmpItems 再往里丢新一行的item
                    [tmpItems removeAllObjects];
                    [tmpItems addObject:curAttr];
                    continue;
                }
                
                // 非行内第一个 丢去待处理
                [tmpItems addObject:curAttr];
                continue;
            }
            
        }
        
        if (self.itemAlignment == VECollectionViewFlowLayoutAlignmentRight) {
            // 这里 倒序操作 比较方便，但是copy两份代码有点low
        }
    }
    
    // 这里加上自定义布局
    for (UICollectionViewLayoutAttributes *att in self.decorationViewAttrs) {
        [attrs addObject:att];
    }
    return attrs;
}

#pragma mark - Private Func
- (CGRect)itemsAreaAtSection:(NSInteger)section {
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    CGRect sectionFrame = CGRectMake(0, 0, self.collectionView.width, 0);
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        sectionFrame.size = CGSizeMake(0, self.collectionView.height);
    }
    
    if (numberOfItems > 0) {
        UICollectionViewLayoutAttributes *first = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        UICollectionViewLayoutAttributes *last = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:numberOfItems - 1 inSection:section]];
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            // 垂直滚动，更新 origin.y 和 size.height
            sectionFrame.origin.y = first.frame.origin.y;
            sectionFrame.size.height = last.frame.origin.y + last.frame.size.height - first.frame.origin.y;
        } else {
            // 横向滚动，更新 origin.x 和 size.width
            CGFloat x = first.frame.origin.x;
            CGFloat right = CGRectGetMaxX(first.frame);
            for (int i = 1; i < numberOfItems; i++) {
                UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
                if (x > att.frame.origin.x) {
                    x = att.frame.origin.x;
                }
                if (right < CGRectGetMaxX(att.frame)) {
                    right = CGRectGetMaxX(att.frame);
                }
            }
            sectionFrame.origin.x = x;
            sectionFrame.size.width = right - x;
        }
    }
    id <VECollectionViewDelegateFlowLayout> delegate  = (id <VECollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if (delegate && [delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        UIEdgeInsets insets = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            sectionFrame.origin.y -= insets.top;
            sectionFrame.size.height += insets.top + insets.bottom;
        } else {
            sectionFrame.origin.x -= insets.left;
            sectionFrame.size.width += insets.left + insets.right;
        }
    }
    return sectionFrame;
}

#pragma mark - Get
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)decorationViewAttrs{
    if (!_decorationViewAttrs) {
        _decorationViewAttrs = [NSMutableArray array];
    }
    return _decorationViewAttrs;
}

@end
