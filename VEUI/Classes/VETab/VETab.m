//
//  VETab.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/3/10.
//

#import "VETab.h"
#import <VEUI/VEUI.h>
#import "VETabContentItem.h"
#import "VETabLineView.h"
#import "VETabContentCollectionView.h"

#define VETAB_Tab_CELL_REUSE_IDENTIFIER @"VETAB_Tab_CELL_REUSE_IDENTIFIER"
#define VETAB_Content_CELL_REUSE_IDENTIFIER @"VETAB_Content_CELL_REUSE_IDENTIFIER"

@interface VETab ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)NSMutableDictionary *contentCache;

@property(nonatomic, strong)UICollectionView *colV;
@property(nonatomic, strong)VETabContentCollectionView *contentV;
@property(nonatomic, strong)VETabLineView *lineView;

@property(nonatomic, assign)CGFloat itemWidth;
@property(nonatomic, assign)NSInteger itemCount;

@property(nonatomic, assign)BOOL layoutTag;
@property(nonatomic, assign)BOOL isClickTab;

@property(nonatomic, strong)NSMutableDictionary *tabProgressCache;
@property(nonatomic, assign)NSInteger contentScrollDirection; // -1 left -- 1 right

@end

@implementation VETab

- (instancetype)initWithStyle:(VETabStyle)style {
    if (self = [super init]) {
        [self setUI];
        _style = style;
        self.itemCount = 0;
        self.contentCache = [NSMutableDictionary dictionary];
        self.tabProgressCache = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public
- (void)reloadTab {
    if (self.colV) {
        [self.colV reloadData];
        [self collectionView:self.colV didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    }
}
- (void)forceReloadTab {
    if (self.colV) {
        [self.colV reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self collectionView:self.colV didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    }
}

- (void)reloadContent {
    if (self.contentV) {
        [self.contentV reloadData];
    }
}
- (void)forceReloadContent {
    if (self.contentV) {
        self.contentCache = [NSMutableDictionary dictionary];
        [self.contentV reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

- (VETabItem *)tabItemAtIndex:(NSInteger)index {
    return (VETabItem *)[self.colV dequeueReusableCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (__kindof VETabItem *)tabItemAtIndex:(NSInteger)index withReuseIdentifier:(NSString *)identifier {
    return [self.colV dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)registerTabItemClass:(nullable Class)itemClass forItemWithReuseIdentifier:(NSString *)identifier {
    [self.colV registerClass:itemClass forCellWithReuseIdentifier:identifier];
}

#pragma mark - UI
- (void)initParams {
    self.backgroundColor = [UIColor whiteColor];
    self.itemWidth = 60;
    self.itemHeight = 40;
    self.lineHeight = 1.5;
    [self setCurrentIndex:0];
    
    self.tabBarBackgroundColor = [UIColor clearColor];
    self.contentBackgroundColor = [UIColor clearColor];
}

- (void)setUI {
    [self initParams];
    [self addSubview:self.colV];
    [self addSubview:self.contentV];
    
    self.lineView = [[VETabLineView alloc] initWithFrame:CGRectMake(0, 0, 0, self.lineHeight)];
    self.lineView.backgroundColor = [UIColor clearColor];
    [self.colV addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.colV.scrollEnabled = self.tabScrollEnabled;
    self.contentV.scrollEnabled = self.contentScrollEnabled;
    self.colV.frame = CGRectMake(0, 0, self.width, self.itemHeight);
    self.contentV.frame = CGRectMake(0, self.itemHeight, self.width, self.height - self.itemHeight);
    self.lineView.height = self.lineHeight;
    self.lineView.maxY = self.itemHeight;
    
    if (!self.layoutTag && self.contentV.width && self.itemCount) {
        [self setSelectedIndex:self.selectedIndex animated:self.contentScrollEnabled];
        self.layoutTag = 1;
    }
}

#pragma mark - Utils
- (NSString *)stringKeyWithIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%d.%d", (int)indexPath.section, (int)indexPath.row];
}

- (void)loadContentAtIndexPath:(NSIndexPath *)indexPath {
    [self.contentCache setValue:[self.dataSource tab:self contentViewAtIndex:indexPath.row]
                         forKey:[self stringKeyWithIndexPath:indexPath]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentV reloadData];
    });
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(numberOfTabItems)]) {
        self.itemCount = [self.dataSource numberOfTabItems];
        return self.itemCount;
    }
    self.itemCount = 0;
    return self.itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.layoutTag && self.itemCount) {
        // 第一次
        self.layoutTag = 1;
        [self setSelectedIndex:self.selectedIndex animated:NO];
        [self didEndScrollHandler];
    }
    if (collectionView == self.contentV) {
        // 内容页
        VETabContentItem *cell = (VETabContentItem *)[collectionView dequeueReusableCellWithReuseIdentifier:VETAB_Content_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
        
        UIView *layoutView = nil;
        NSString *strKey = [self stringKeyWithIndexPath:indexPath];
        if ([self.contentCache.allKeys containsObject:strKey]) {
            layoutView = [self.contentCache objectForKey:strKey];
        } else {
            layoutView = [[UIView alloc] init];
            layoutView.backgroundColor = self.contentBackgroundColor;
        }
        cell.layoutView = layoutView;
        return cell;
    }
    if (collectionView == self.colV) {
        // tab
        VETabItem *cell;
        if ([self.dataSource respondsToSelector:@selector(tab:tabItemAtIndex:)]) {
            cell = [self.dataSource tab:self tabItemAtIndex:indexPath.row];
        }
        if (!cell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
        }
        // 处理渐变色
        NSString *strKey = [self stringKeyWithIndexPath:indexPath];
        if ([self.tabProgressCache.allKeys containsObject:strKey]) {
            cell.selectProgress = [[self.tabProgressCache valueForKey:strKey] floatValue];
        }
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.contentV) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else {
        // tab
        self.isClickTab = YES;
        [self setSelectedIndex:indexPath.row animated:self.contentScrollEnabled];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.contentV) {
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.colV) {
        return UIEdgeInsetsMake(0, self.tabVerticalGap, 0, self.tabVerticalGap);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.colV) {
        return self.tabItemGap;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.colV) {
        return self.tabItemGap;
    }
    return CGFLOAT_MIN;
}

#pragma mark - UIScrollViewDelegate
- (void)didEndScrollHandler {
    NSInteger index = self.contentV.contentOffset.x / self.contentV.width;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if (self.selectedIndex != index) {
        [self setCurrentIndex:index];
        [self.colV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    NSString *strKey = [self stringKeyWithIndexPath:indexPath];
    if (![self.contentCache.allKeys containsObject:strKey] && [self.dataSource respondsToSelector:@selector(tab:contentViewAtIndex:)]) {
        [self loadContentAtIndexPath:indexPath];
    }
    
    self.isClickTab = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentV) {
        [self didEndScrollHandler];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentV) {
        [self didEndScrollHandler];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.colV bringSubviewToFront:self.lineView];
    if (scrollView == self.contentV) { // content view
        // 点击了选中状态的tab
        if (self.isClickTab && self.selectedIndex * self.contentV.width == self.contentV.contentOffset.x) {
            [self scrollViewDidEndScrollingAnimation:scrollView];
            return;
        }
        
        CGFloat progress = self.contentV.contentOffset.x / self.contentV.width;
        int left = (int)progress;
        int right = left + 1 > self.itemCount - 1 ? left : left + 1;
        progress -= left;
        
        NSIndexPath *leftIndexPath = [NSIndexPath indexPathForRow:left inSection:0];
        NSIndexPath *rightIndexPath = [NSIndexPath indexPathForRow:right inSection:0];
        
        VETabItem *leftItem = [self collectionView:self.colV cellForItemAtIndexPath:leftIndexPath];
        VETabItem *rightItem = [self collectionView:self.colV cellForItemAtIndexPath:rightIndexPath];
        
        // 👇👇👇👇👇 lineView 👇👇👇👇👇
        self.lineView.backgroundColor = [UIColor colorFromColor:leftItem.activeColor toColor:rightItem.activeColor progress:fabs(progress)];
        self.lineView.x = leftItem.x + (rightItem.x - leftItem.x) * fabs(progress);
        self.lineView.width = leftItem.width + (rightItem.width - leftItem.width) * fabs(progress);
        
        self.lineView.x = leftItem.x + (rightItem.x - leftItem.x) * progress;
        switch (self.style) {
            case VETabStyleLineEqual:
                {
                    CGFloat leftGap = leftItem.width - leftItem.textWidth;
                    CGFloat rightGap = rightItem.width - rightItem.textWidth;
                    self.lineView.horizontalGap = leftGap * (1 - progress) + rightGap * progress;
                }
                break;
            default:
                self.lineView.horizontalGap = 0;
                break;
        }
        // 👆👆👆👆👆 lineView 👆👆👆👆👆
        // 👇👇👇👇👇 tabItem check 👇👇👇👇👇
        if (!self.isClickTab && self.contentScrollDirection != 0) {
            // 不是点击tab的时候 -- 点击tab 不管它
            if (self.lineView.x < self.colV.contentOffset.x || self.lineView.maxX - self.colV.width > self.colV.contentOffset.x) {
                // lineView 被遮挡，操作一下放出来，
                CGFloat shouldAdjust = 0;
                if (self.lineView.x < self.colV.contentOffset.x) {
                    shouldAdjust = self.lineView.x;
                }
                if (self.lineView.maxX - self.colV.contentOffset.x > self.colV.width) {
                    shouldAdjust = self.lineView.maxX - self.colV.width;
                }
                [self.colV setContentOffset:CGPointMake(shouldAdjust, 0) animated:NO];
            }
        }
        // 👆👆👆👆👆 tabItem check 👆👆👆👆👆
        // 👇👇👇👇👇 refresh collectionView 👇👇👇👇👇
        NSString *leftKey = [self stringKeyWithIndexPath:leftIndexPath];
        NSString *rightKey = [self stringKeyWithIndexPath:rightIndexPath];
        for (NSString *key in self.tabProgressCache.allKeys) {
            if (![key isEqualToString:leftKey] && ![key isEqualToString:rightKey]) {
                [self.tabProgressCache setValue:[NSNumber numberWithFloat:0] forKey:key];
            }
        }
        if ([leftKey isEqualToString:rightKey]) {
            // 处理最后一个tab
            [self.tabProgressCache setValue:[NSNumber numberWithFloat:1] forKey:leftKey];
        } else {
            [self.tabProgressCache setValue:[NSNumber numberWithFloat:(1 - progress)] forKey:leftKey];
            [self.tabProgressCache setValue:[NSNumber numberWithFloat:progress] forKey:rightKey];
        }
        if ([leftIndexPath isEqual:rightIndexPath]) {
            [self.colV reloadItemsAtIndexPaths:@[leftIndexPath]];
        } else {
            [self.colV reloadItemsAtIndexPaths:@[leftIndexPath, rightIndexPath]];
        }
        // 👆👆👆👆👆 refresh collectionView 👆👆👆👆👆
    }
}

#pragma mark - Observation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat oldX = [change[NSKeyValueChangeOldKey] CGPointValue].x;
        CGFloat newX = [change[NSKeyValueChangeNewKey] CGPointValue].x;
        CGFloat deltaY = newX - oldX;
        if (deltaY > 0) {
            self.contentScrollDirection = 1;
        } else if (deltaY < 0) {
            self.contentScrollDirection = -1;
        } else {
            self.contentScrollDirection = 0;
        }
    }
}

#pragma mark - Set
@synthesize selectedIndex = _selectedIndex;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (self.selectedIndex != selectedIndex) {
        NSInteger oldIndex = self.selectedIndex;
        [self.contentV setContentOffset:CGPointMake(selectedIndex * self.contentV.width, 0) animated:animated];
        if (!animated) {
            __weak typeof(self) ws = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws didEndScrollHandler];
                [ws.colV reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldIndex inSection:0]]];
            });
        }
        [self.colV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    } else {
        [self scrollViewDidScroll:self.contentV];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_selectedIndex != currentIndex) {
        _selectedIndex = currentIndex;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectAtIndex:)]) {
        [self.delegate didSelectAtIndex:currentIndex];
    }
}

- (void)setTabBarBackgroundColor:(UIColor *)tabBarBackgroundColor {
    _tabBarBackgroundColor = tabBarBackgroundColor;
    self.colV.backgroundColor = tabBarBackgroundColor;
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor {
    _contentBackgroundColor = contentBackgroundColor;
    self.contentV.backgroundColor = contentBackgroundColor;
}

#pragma mark - Get
- (UICollectionView *)colV {
    if (!_colV) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        
        UICollectionView *colV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        colV.bounces = NO;
        colV.delegate = self;
        colV.dataSource = self;
        colV.showsVerticalScrollIndicator = NO;
        colV.showsHorizontalScrollIndicator = NO;
        colV.backgroundColor = [UIColor clearColor];
        [colV registerClass:[VETabItem class] forCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER];
        _colV = colV;
    }
    return _colV;
}

- (VETabContentCollectionView *)contentV {
    if (!_contentV) {
        _contentV = [VETabContentCollectionView contentView];
        _contentV.delegate = self;
        _contentV.dataSource = self;
        [_contentV registerClass:[VETabContentItem class] forCellWithReuseIdentifier:VETAB_Content_CELL_REUSE_IDENTIFIER];
        [_contentV addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return _contentV;
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
