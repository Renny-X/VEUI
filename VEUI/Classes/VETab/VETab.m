//
//  VETab.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/3/10.
//

#import "VETab.h"
#import <VEUI/VEUI.h>
#import "VETabContentItem.h"

#define VETAB_Tab_CELL_REUSE_IDENTIFIER @"VETAB_Tab_CELL_REUSE_IDENTIFIER"
#define VETAB_Content_CELL_REUSE_IDENTIFIER @"VETAB_Content_CELL_REUSE_IDENTIFIER"

@interface VETab ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)NSMutableArray *contentArr;

@property(nonatomic, strong)UICollectionView *colV;
@property(nonatomic, strong)UICollectionView *contentV;
@property(nonatomic, assign)CGFloat itemWidth;

@property(nonatomic, assign)NSInteger layoutTag;
@property(nonatomic, assign)BOOL contentIsDrag;

@property(nonatomic, assign)NSInteger itemCount;

@property(nonatomic, strong)UIView *lineView;

@property(nonatomic, assign)NSInteger nextIndex;
@property(nonatomic, assign)CGFloat selectProgress;

@end

@implementation VETab

- (instancetype)initWithStyle:(VETabStyle)style {
    if (self = [super init]) {
        [self setUI];
        _style = style;
        self.itemCount = 0;
        _selectedIndex = -1;
        self.contentArr = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public
- (void)reloadTab {
    if (self.colV) {
        [self.colV reloadData];
        [self setSelectedIndex:self.selectedIndex animate:YES];
    }
}

- (void)reloadContent {
    if (self.contentV) {
        self.contentArr = [NSMutableArray array];
        [self.contentV reloadData];
    }
}

- (VETabItem *)tabItemAtIndex:(NSInteger)index {
    return (VETabItem *)[self.colV dequeueReusableCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - UI
- (void)initParams {
    self.backgroundColor = [UIColor whiteColor];
    self.itemWidth = 60;
    self.itemHeight = 40;
    self.lineHeight = 1.5;
}

- (void)setUI {
    [self initParams];
    [self addSubview:self.colV];
    [self addSubview:self.contentV];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.lineHeight)];
    self.lineView.backgroundColor = [UIColor clearColor];
    [self.colV addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.layoutTag) {
        [self setSelectedIndex:self.selectedIndex >= 0 ?: 0 animate:YES];
        self.layoutTag = 1;
    }
    self.colV.scrollEnabled = self.tabScrollEnabled;
    self.contentV.scrollEnabled = self.contentScrollEnabled;
    self.colV.frame = CGRectMake(0, 0, self.width, self.itemHeight);
    self.contentV.frame = CGRectMake(0, self.itemHeight, self.width, self.height - self.itemHeight);
    self.lineView.maxY = self.itemHeight;
}

#pragma mark - Data Handler
- (void)checkArrWithCount:(NSInteger)count {
    while (self.contentArr.count < count) {
        [self.contentArr addObject:[NSNull null]];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(numberOfTabItems)]) {
        self.itemCount = [self.dataSource numberOfTabItems];
        return self.itemCount;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self checkArrWithCount:indexPath.row + 1];
    if (collectionView.tag % 10) {
        // 内容页
        VETabContentItem *cell = (VETabContentItem *)[collectionView dequeueReusableCellWithReuseIdentifier:VETAB_Content_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
        UIView *layoutView = [self.contentArr objectAtIndex:indexPath.row];
        if (![layoutView isKindOfClass:[UIView class]]) {
            layoutView = nil;
            if ([self.dataSource respondsToSelector:@selector(tab:contentViewAtIndex:)]) {
                layoutView = [self.dataSource tab:self contentViewAtIndex:indexPath.row];
            }
            if (!layoutView) {
                layoutView = [[UIView alloc] init];
                layoutView.backgroundColor = [UIColor whiteColor];
            }
            [self.contentArr replaceObjectAtIndex:indexPath.row withObject:layoutView];
        }
        cell.layoutView = layoutView;
        return cell;
    }
    // tab
    VETabItem *cell;
    if ([self.dataSource respondsToSelector:@selector(tab:tabItemAtIndex:)]) {
        cell = [self.dataSource tab:self tabItemAtIndex:indexPath.row];
    }
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    }
    if (self.contentIsDrag) {
        if (indexPath.row == self.selectedIndex) {
            cell.selectProgress = self.selectProgress;
        } else if (indexPath.row == self.nextIndex) {
            cell.selectProgress = 1 - self.selectProgress;
        } else {
            cell.selectProgress = 0;
        }
    } else {
        if (cell.selected) {
            cell.selectProgress = 1;
        }
    }
    if (!self.lineView.width && cell.selected) {
        [self.colV bringSubviewToFront:self.colV];
        self.lineView.width = cell.width;
        self.lineView.x = cell.x;
        self.lineView.backgroundColor = cell.activeColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag % 10) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else {
        // tab
        _selectedIndex = indexPath.row;
        [self setSelectedIndex:indexPath.row animate:NO];
        self.contentIsDrag = YES;
        [self.contentV.delegate scrollViewDidScroll:self.contentV];
        self.contentIsDrag = NO;
        if ([self.delegate respondsToSelector:@selector(didSelectAtIndex:)]) {
            [self.delegate didSelectAtIndex:indexPath.row];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag % 10) {
        if (collectionView.width <= 0 || collectionView.height <= 0) {
            return CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        }
        return collectionView.size;
    }
    if ([self.dataSource respondsToSelector:@selector(tab:tabItemWidthAtIndex:)]) {
        CGFloat width = [self.dataSource tab:self tabItemWidthAtIndex:indexPath.row];
        if (width > 0) {
            return CGSizeMake(width, self.itemHeight);
        }
    }
    return CGSizeMake(self.itemWidth, self.itemHeight);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag % 10) {
        // content
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        [self setSelectedIndex:index animate:NO];
        self.contentIsDrag = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.tag % 10) {
        self.contentIsDrag = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.colV bringSubviewToFront:self.lineView];
    if (scrollView.tag % 10) {
        // content
        if (self.contentIsDrag) {
            NSInteger total = [self collectionView:self.colV numberOfItemsInSection:0];
            if (total) {
                CGFloat shouldOffset = self.selectedIndex * self.contentV.width;
                CGFloat progress = (self.contentV.contentOffset.x - shouldOffset) / self.contentV.width;
                self.selectProgress = 1 - fabs(progress);
                self.nextIndex = self.selectedIndex + (progress >= 0 ? 1 : -1);
                if (self.nextIndex > total - 1) {
                    self.nextIndex = total - 1;
                }
                if (self.nextIndex < 0) {
                    self.nextIndex = 0;
                }
                NSIndexPath *thisIndexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
                NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:self.nextIndex inSection:0];
                [self.colV reloadItemsAtIndexPaths:@[thisIndexPath, nextIndexPath]];
                [self.colV selectItemAtIndexPath:thisIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                
                VETabItem *thisItem = [self collectionView:self.colV cellForItemAtIndexPath:thisIndexPath];
                VETabItem *nextItem = [self collectionView:self.colV cellForItemAtIndexPath:nextIndexPath];
                CGRect thisItemFrame = thisItem.frame;
                CGRect nextItemFrame = nextItem.frame;
                
                self.lineView.backgroundColor = [UIColor colorFromColor:thisItem.activeColor toColor:nextItem.activeColor progress:fabs(progress)];
                self.lineView.x = thisItemFrame.origin.x + (nextItemFrame.origin.x - thisItemFrame.origin.x) * fabs(progress);
                self.lineView.width = thisItem.width + (nextItem.width - thisItem.width) * fabs(progress);
            }
        }
    }
}

#pragma mark - Set
- (void)setSelectedIndex:(NSInteger)selectedIndex animate:(BOOL)animate {
    if ([self.dataSource respondsToSelector:@selector(numberOfTabItems)]) {
        self.itemCount = [self.dataSource numberOfTabItems];
    }
    if (self.itemCount > selectedIndex && selectedIndex >= 0) {
        _selectedIndex = selectedIndex;
        [self.colV selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:animate scrollPosition:UICollectionViewScrollPositionNone];
        [self.contentV setContentOffset:CGPointMake(selectedIndex * self.contentV.width, 0) animated:animate];
        
        VETabItem *item = [self collectionView:self.colV cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        // 检查是否显示不完全
        if (item.x < self.colV.contentOffset.x || item.maxX - self.colV.contentOffset.x > self.colV.width) {
            // 左边被遮挡 || 右边被遮挡
            CGFloat maxOffset = self.colV.contentSize.width - self.colV.width;
            CGFloat minOffset = 0;
            CGFloat shouldOffset = item.x - (self.colV.width - item.width) / 2.0;
            if (shouldOffset < minOffset) {
                shouldOffset = minOffset;
            }
            if (shouldOffset > maxOffset) {
                shouldOffset = maxOffset;
            }
            [self.colV setContentOffset:CGPointMake(shouldOffset, 0) animated:YES];
        }
    }
}

#pragma mark - Get
- (UICollectionView *)colV {
    if (!_colV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        
        _colV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _colV.tag = 1000;
        _colV.bounces = NO;
        _colV.delegate = self;
        _colV.dataSource = self;
        _colV.showsVerticalScrollIndicator = NO;
        _colV.showsHorizontalScrollIndicator = NO;
        _colV.backgroundColor = [UIColor clearColor];
        [_colV registerClass:[VETabItem class] forCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER];
    }
    return _colV;
}

- (UICollectionView *)contentV {
    if (!_contentV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        
        _contentV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _contentV.tag = 1001;
        _contentV.bounces = NO;
        _contentV.delegate = self;
        _contentV.dataSource = self;
        _contentV.pagingEnabled = YES;
        _contentV.showsVerticalScrollIndicator = NO;
        _contentV.showsHorizontalScrollIndicator = NO;
        _contentV.backgroundColor = [UIColor clearColor];
        [_contentV registerClass:[VETabContentItem class] forCellWithReuseIdentifier:VETAB_Content_CELL_REUSE_IDENTIFIER];
    }
    return _contentV;
}

@synthesize selectedIndex = _selectedIndex;
- (NSInteger)selectedIndex {
    if (!_selectedIndex) {
        _selectedIndex = 0;
    }
    return _selectedIndex;
}

#pragma mark- tab scroll enabled
@synthesize tabScrollEnabled = _tabScrollEnabled;
- (BOOL)tabScrollEnabled {
    return self.colV.scrollEnabled;
}

- (void)setTabScrollEnabled:(BOOL)tabScrollEnabled {
    _tabScrollEnabled = tabScrollEnabled;
    self.colV.scrollEnabled = tabScrollEnabled;
}

#pragma mark- tab scroll enabled
@synthesize contentScrollEnabled = _contentScrollEnabled;
- (BOOL)contentScrollEnabled {
    return self.contentV.scrollEnabled;
}

- (void)setContentScrollEnabled:(BOOL)contentScrollEnabled {
    _contentScrollEnabled = contentScrollEnabled;
    [self.contentV setScrollEnabled:contentScrollEnabled];
}



@end
