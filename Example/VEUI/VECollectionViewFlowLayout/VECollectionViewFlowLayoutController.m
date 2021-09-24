//
//  VECollectionViewFlowLayoutController.m
//  VEUI_Example
//
//  Created by Coder on 2021/6/25.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VECollectionViewFlowLayoutController.h"
#import "VEUI.h"

#define VECOLLECTIONVIEW_LEFT_FLOWLAYOUT_ITEM @"VECOLLECTIONVIEW_LEFT_FLOWLAYOUT_ITEM"

@interface VECollectionViewFlowLayoutController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, VECollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UICollectionView *colV;

@property(nonatomic, strong)NSArray *dataArray;

@end

@implementation VECollectionViewFlowLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.colV];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.colV.frame = self.view.bounds;
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *rows = [self.dataArray safe_objectAtIndex:section];
    return rows ? rows.count : 0;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VECOLLECTIONVIEW_LEFT_FLOWLAYOUT_ITEM forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor randomColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = [self.dataArray safe_objectAtIndex:indexPath.section];
    if (rows) {
        CGFloat width = [[rows safe_objectAtIndex:indexPath.row] floatValue];
        return CGSizeMake(width, 25);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout backgroundColorAtSection:(NSInteger)section {
    return [UIColor randomColor];
}

- (UIView *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundViewAtSection:(NSInteger)section sectionFrame:(CGRect)frame {
    CGFloat gap = 5;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(gap, gap, frame.size.width - gap * 2, frame.size.height - gap * 2)];
    view.backgroundColor = [UIColor linerColorWithColors:@[
        [UIColor randomColor],
        [UIColor randomColor],
    ] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0) colorSize:view.size locations:nil];
    
    [view addCornerRadius:15];
    
    return view;
}

#pragma mark - Get
- (UICollectionView *)colV {
    if (!_colV) {
        VECollectionViewFlowLayout *flowLayout = [[VECollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.itemAlignment = VECollectionViewFlowLayoutAlignmentLeft;
//        flowLayout.itemAlignment = VECollectionViewFlowLayoutAlignmentRight;
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _colV = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _colV.backgroundColor = UIColor.whiteColor;
        _colV.delegate = self;
        _colV.dataSource = self;
        [_colV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:VECOLLECTIONVIEW_LEFT_FLOWLAYOUT_ITEM];
    }
    return _colV;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        int sections = randomNum(5, 15);
        NSMutableArray *secArr = [NSMutableArray array];
        for (int s = 0; s < sections; s++) {
            int rows = randomNum(5, 40);
            NSMutableArray *rowArr = [NSMutableArray array];
            for (int r = 0; r < rows; r++) {
                [rowArr addObject:[NSNumber numberWithInt:randomNum(20, 200)]];
            }
            [secArr addObject:rowArr];
        }
        _dataArray = [NSArray arrayWithArray:secArr];
    }
    return _dataArray;
}

@end
