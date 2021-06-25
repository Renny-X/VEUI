//
//  VECollectionViewFlowLayout.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/6/25.
//

#import "VECollectionViewFlowLayout.h"
#import "VECollectionViewLayoutAttributes.h"
#import "VECollectionSectionBackView.h"

#define VECollectionViewSection @"VECollectionViewDelegateFlowLayout"

@interface VECollectionViewFlowLayout ()

@property(nonatomic, strong)NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end

@implementation VECollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger sections = [self.collectionView numberOfSections];
    id <VECollectionViewDelegateFlowLayout> delegate  = (id <VECollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    if (![delegate respondsToSelector:@selector(collectionView:layout:backgroundColorAtSection:)]) {
        return;
    }
    
    [self registerClass:[VECollectionSectionBackView class] forDecorationViewOfKind:VECollectionViewSection];
    [self.decorationViewAttrs removeAllObjects];
    
    for (NSInteger section = 0; section < sections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        
        CGRect sectionFrame = CGRectMake(0, 0, self.collectionView.frame.size.width, 0);
        
        if (numberOfItems > 0) {
            UICollectionViewLayoutAttributes *first = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            sectionFrame.origin.y = first.frame.origin.y;
            
            UICollectionViewLayoutAttributes *last = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:numberOfItems - 1 inSection:section]];
            sectionFrame.size.height = last.frame.origin.y + last.frame.size.height;
        }
        
        VECollectionViewLayoutAttributes *attrs = [VECollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:VECollectionViewSection withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        attrs.frame = sectionFrame;
        attrs.zIndex = -1;
        attrs.backgroundColor = [delegate collectionView:self.collectionView layout:self backgroundColorAtSection:section];
        
        [self.decorationViewAttrs addObject:attrs];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attrs = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    for (UICollectionViewLayoutAttributes *att in self.decorationViewAttrs) {
        [attrs addObject:att];
    }
    
    return attrs;
}

#pragma mark - Get
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)decorationViewAttrs{
    if (!_decorationViewAttrs) {
        _decorationViewAttrs = [NSMutableArray array];
    }
    return _decorationViewAttrs;
}

@end
