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

#define VETAB_Tab_CELL_REUSE_IDENTIFIER @"VETAB_Tab_CELL_REUSE_IDENTIFIER"
#define VETAB_Content_CELL_REUSE_IDENTIFIER @"VETAB_Content_CELL_REUSE_IDENTIFIER"

@interface VETab ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)NSMutableArray *contentArr;

@property(nonatomic, strong)UICollectionView *colV;
@property(nonatomic, strong)UICollectionView *contentV;
@property(nonatomic, strong)VETabLineView *lineView;

@property(nonatomic, assign)CGFloat itemWidth;
@property(nonatomic, assign)NSInteger itemCount;

@property(nonatomic, assign)BOOL layoutTag;
@property(nonatomic, assign)BOOL isClickTab;

@property(nonatomic, assign)NSInteger nextIndex;
@property(nonatomic, assign)CGFloat selectProgress;

@end

@implementation VETab

- (instancetype)initWithStyle:(VETabStyle)style {
    if (self = [super init]) {
        [self setUI];
        _style = style;
        self.itemCount = 0;
        self.contentArr = [NSMutableArray array];
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
        self.contentArr = [NSMutableArray array];
        [self.contentV reloadData];
    }
}
- (void)forceReloadContent {
    if (self.contentV) {
        self.contentArr = [NSMutableArray array];
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
        [self setSelectedIndex:self.selectedIndex animated:NO];
        self.layoutTag = 1;
    }
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
    self.itemCount = 0;
    return self.itemCount;
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
    // 处理渐变色
    cell.selectProgress = 0;
    if (indexPath.row == self.selectedIndex) {
        cell.selectProgress = self.selectProgress;
    } else if (indexPath.row == self.nextIndex) {
        cell.selectProgress = 1 - self.selectProgress;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag % 10) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else {
        // tab
        self.isClickTab = YES;
        [self setSelectedIndex:indexPath.row animated:NO];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.colV bringSubviewToFront:self.lineView];
    if (scrollView.tag % 10) {
        // content
        // 从selected -> next
        if (self.isClickTab && self.selectedIndex * self.contentV.width == self.contentV.contentOffset.x) {
            // 点击了选中状态的tab
            [self.colV selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            self.isClickTab = NO;
            return;
        }
        if (self.itemCount && scrollView.width) {
            CGFloat shouldOffset = 0;
            CGFloat progress = 1;
            //
            if (self.isClickTab) {
                // 直接干它
                self.nextIndex = scrollView.contentOffset.x / scrollView.width;
            } else {
                // 慢慢干
                shouldOffset = self.selectedIndex * self.contentV.width;
                progress = (self.contentV.contentOffset.x - shouldOffset) / self.contentV.width;
                if (fabs(progress) > 1) {
                    int tmp = (int)progress;
                    [self setCurrentIndex:self.selectedIndex + tmp];
                    progress -= tmp;
                }
                self.nextIndex = self.selectedIndex + (progress >= 0 ? 1 : -1);
            }
            if (self.nextIndex > self.itemCount - 1) {
                self.nextIndex = self.itemCount - 1;
            }
            if (self.nextIndex < 0) {
                self.nextIndex = 0;
            }
            self.selectProgress = 1 - fabs(progress);
            NSIndexPath *thisIndexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:self.nextIndex inSection:0];
            
            // 处理lineView.width
            VETabItem *thisItem = [self collectionView:self.colV cellForItemAtIndexPath:thisIndexPath];
            VETabItem *nextItem = [self collectionView:self.colV cellForItemAtIndexPath:nextIndexPath];
            CGRect thisItemFrame = thisItem.frame;
            CGRect nextItemFrame = nextItem.frame;
            
            self.lineView.backgroundColor = [UIColor colorFromColor:thisItem.activeColor toColor:nextItem.activeColor progress:fabs(progress)];
            self.lineView.x = thisItemFrame.origin.x + (nextItemFrame.origin.x - thisItemFrame.origin.x) * fabs(progress);
            self.lineView.width = thisItem.width + (nextItem.width - thisItem.width) * fabs(progress);
            
            if (self.style == VETabStyleLineEqual) {
                CGFloat curProgress = fabs(progress);
                CGFloat thisGap = thisItem.width - thisItem.textWidth;
                CGFloat nextGap = nextItem.width - nextItem.textWidth;
                self.lineView.horizontalGap = thisGap * (1 - curProgress) + nextGap * curProgress;
            }
            
            // 检查是否显示不完全
            if (self.lineView.x < self.colV.contentOffset.x || self.lineView.maxX - self.colV.contentOffset.x > self.colV.width) {
                // 左边被遮挡 || 右边被遮挡
                CGFloat shouldAdjust = 0;
                if (self.lineView.x < self.colV.contentOffset.x) {
                    shouldAdjust = self.lineView.x;
                }
                if (self.lineView.maxX - self.colV.contentOffset.x > self.colV.width) {
                    shouldAdjust = self.lineView.maxX - self.colV.width;
                }
                [self.colV setContentOffset:CGPointMake(shouldAdjust, 0) animated:NO];
            }
            
            // 刷新 Tab
            if (self.selectProgress == 0) {
                // 切换下选中状态
                [self setCurrentIndex:self.nextIndex];
                self.selectProgress = 1;
                self.nextIndex = -1;
            }
            [self.colV reloadItemsAtIndexPaths:@[thisIndexPath, nextIndexPath]];
            [self.colV selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        self.isClickTab = NO;
    }
}

#pragma mark - Set
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (self.selectedIndex != selectedIndex) {
        [self.contentV setContentOffset:CGPointMake(selectedIndex * self.contentV.width, 0) animated:animated];
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

#pragma mark - Get
- (UICollectionView *)colV {
    if (!_colV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
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
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
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
