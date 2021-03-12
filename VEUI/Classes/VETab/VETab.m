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

@property(nonatomic, strong)NSArray<NSString *> *titleArr;
@property(nonatomic, strong)NSArray<UIView *> *subContentViews;

@property(nonatomic, strong)UICollectionView *colV;
@property(nonatomic, strong)UICollectionView *contentV;
@property(nonatomic, assign)CGFloat itemWidth;

@property(nonatomic, assign)NSInteger layoutTag;

@end

@implementation VETab

#pragma mark - Public
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles {
    return [self initWithTitles:titles contentViews:nil];
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles contentViews:(NSArray<UIView *> * __nullable)contentViews {
    if (self = [super init]) {
        [self initParams];
        
        self.titleArr = titles && titles.count ? [NSArray arrayWithArray:titles] : [NSArray array];
        self.subContentViews = contentViews && contentViews.count ? [NSArray arrayWithArray:contentViews] : [NSArray array];
        
        [self setUI];
    }
    return self;
}

- (void)reloadTab {
    if (self.colV) {
        [self.colV reloadData];
    }
}

- (void)reloadContent {
    if (self.contentV) {
        [self.contentV reloadData];
    }
}

#pragma mark - UI
- (void)initParams {
    self.backgroundColor = [UIColor whiteColor];
    self.itemWidth = 60;
    self.activeColor = [UIColor colorWithHexString:@"#09f"];
    self.inactiveColor = [UIColor colorWithHexString:@"#000"];
    self.itemHeight = 40;
    self.titleFont = [UIFont systemFontOfSize:16];
}

- (void)setUI {
    [self addSubview:self.colV];
    [self addSubview:self.contentV];
    
    if (self.titleArr.count) {
        [self collectionView:self.colV didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.colV.scrollEnabled = self.tabScrollEnable;
    self.contentV.scrollEnabled = self.contentScrollEnable;
    
    if (!self.layoutTag) {
        [self setSelectedIndex:self.selectedIndex || 0 animate:YES];
        [self.contentV reloadData];
        self.layoutTag = 1;
    }
    
    self.colV.frame = CGRectMake(0, 0, self.width, self.itemHeight);
    self.contentV.frame = CGRectMake(0, self.itemHeight, self.width, self.height - self.itemHeight);
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag % 10) {
        // 内容页
        VETabContentItem *cell = (VETabContentItem *)[collectionView dequeueReusableCellWithReuseIdentifier:VETAB_Content_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
        UIView *layoutView;
        if ([self.delegate respondsToSelector:@selector(tabContentViewAtIndex:)]) {
            layoutView = [self.delegate tabContentViewAtIndex:indexPath.row];
        }
        if (!layoutView && self.subContentViews && self.subContentViews.count > indexPath.row) {
            UIView *v = [self.subContentViews objectAtIndex:indexPath.row];
            layoutView = v;
        }
        if (!layoutView) {
            layoutView = [[UIView alloc] init];
            layoutView.backgroundColor = [UIColor whiteColor];
        }
        cell.layoutView = layoutView;
        return cell;
    }
    // tab
    VETabItem *cell = (VETabItem *)[collectionView dequeueReusableCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    cell.activeColor = self.activeColor;
    cell.inactiveColor = self.inactiveColor;
    cell.titleFont = self.titleFont;
    cell.title = self.titleArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(tabItemAtIndex:title:tabItem:)]) {
        VETabItem *tmp = [self.delegate tabItemAtIndex:indexPath.row title:self.titleArr[indexPath.row] tabItem:cell];
        if (tmp) {
            return tmp;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag % 10) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else {
        // tab
        if ([self.delegate respondsToSelector:@selector(didSelectAtIndex:)]) {
            [self.delegate didSelectAtIndex:indexPath.row];
        }
        self.contentV.contentOffset = CGPointMake(indexPath.row * self.contentV.width, 0);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag % 10) {
        return collectionView.size;
    }
    if ([self.delegate respondsToSelector:@selector(tabItemWidthAtIndex:title:)]) {
        CGFloat width = [self.delegate tabItemWidthAtIndex:indexPath.row title:self.titleArr[indexPath.row]];
        if (width > 0) {
            return CGSizeMake(width, self.itemHeight);
        }
    }
    return CGSizeMake(self.itemWidth, self.itemHeight);
}

#pragma mark - Set
- (void)setSelectedIndex:(NSInteger)selectedIndex animate:(BOOL)animate {
    if (self.selectedIndex != selectedIndex || !self.layoutTag) {
        if (self.titleArr.count > selectedIndex) {
            [self collectionView:self.colV didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
            [self.colV selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
}

#pragma mark - Get
- (UICollectionView *)colV {
    if (!_colV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.size;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        
        _colV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _colV.tag = 1000;
        _colV.backgroundColor = [UIColor clearColor];
        _colV.delegate = self;
        _colV.dataSource = self;
        _colV.showsHorizontalScrollIndicator = NO;
        _colV.showsVerticalScrollIndicator = NO;
        _colV.scrollEnabled = NO;
        [_colV registerClass:[VETabItem class] forCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER];
    }
    return _colV;
}

- (UICollectionView *)contentV {
    if (!_contentV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.size;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        
        _contentV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _contentV.tag = 1001;
        _contentV.backgroundColor = [UIColor clearColor];
        _contentV.delegate = self;
        _contentV.dataSource = self;
        _contentV.showsHorizontalScrollIndicator = NO;
        _contentV.showsVerticalScrollIndicator = NO;
        _contentV.scrollEnabled = NO;
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

@end
