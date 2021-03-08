//
//  VEUIViewController.m
//  VEUI
//
//  Created by Coder on 02/01/2021.
//  Copyright (c) 2021 Coder. All rights reserved.
//

#import "VEUIViewController.h"
#import "VEUIModel.h"

#import "VEToastViewController.h"
#import "VEImageBrowserViewController.h"
#import "VEUIImageCategoryViewController.h"
#import "VEPopoverViewController.h"

@interface VEUIViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property(nonatomic, strong)UITableView *tableV;
@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic, strong)NSMutableArray *closeSections;

@end

@implementation VEUIViewController

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
            [VEUIGroupModel modelWithTitle:@"Category" cellArr:@[
                [VEUICellModel modelWithTitle:@"UIImage+VEUI" controller:[VEUIImageCategoryViewController new]],
            ]],
            [VEUIGroupModel modelWithTitle:@"Data Display" cellArr:@[
                [VEUICellModel modelWithTitle:@"VEImageBrowser" controller:[VEImageBrowserViewController new]],
            ]],
            [VEUIGroupModel modelWithTitle:@"Feedback" cellArr:@[
                [VEUICellModel modelWithTitle:@"VEToast" controller:[VEToastViewController new]],
            ]],
            [VEUIGroupModel modelWithTitle:@"Navigation" cellArr:@[
                [VEUICellModel modelWithTitle:@"VEPopover" controller:[VEPopoverViewController new]],
            ]],
        ];
    }
    return _dataArr;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = [viewController.title isEqualToString:self.title] ? UINavigationItemLargeTitleDisplayModeAutomatic : UINavigationItemLargeTitleDisplayModeNever;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VEUI Example";
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.backButtonTitle = @"";
    } else {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    self.navigationController.delegate = self;
    
    self.closeSections = [NSMutableArray array];
    
    self.tableV = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.backgroundColor = [UIColor whiteColor];
    self.tableV.sectionFooterHeight = 0;
    [self.tableV addToSuperView:self.view];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
//    btn.center = CGPointMake(self.view.centerX, self.view.height - 120);
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
//    NSDictionary *dict = @{
//        @"键1": @[@"值1", [NSNull null], @{
//                     @"数组键1": @"数组值1", @"数组键2": [NSNull null], @"数组键3": @[@"11", [NSNull null], @"22"]
//        }],
//    };
//    NSLog(@"%@", dict);
//    NSArray *arr = @[@"数组1", [NSNull null], dict];
//
//    NSLog(@"%@", [arr formatValue]);
//    NSLog(@"%@", [dict safeValueForKey:@"键1"]);
}

- (void)btnClicked:(UIButton *)btn {
    
}

- (void)headerClicked:(UIButton *)sender {
    NSInteger section = sender.tag % 1000;
    if ([self.closeSections containsObject:[NSNumber numberWithInteger:section]]) {
        [self.closeSections removeObject:[NSNumber numberWithInteger:section]];
    } else {
        [self.closeSections addObject:[NSNumber numberWithInteger:section]];
    }
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *reloadSections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableV reloadSections:reloadSections withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.closeSections containsObject:[NSNumber numberWithInteger:section]]) {
        return 0;
    }
    VEUIGroupModel *model = self.dataArr[section];
    return model.cellArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *header = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForHeaderInSection:section])];
    [header setBackgroundColor:[UIColor colorWithHexString:@"#eee"] forState:UIControlStateNormal];
    [header setBackgroundColor:[UIColor colorWithHexString:@"#eee"] forState:UIControlStateHighlighted];
    [header addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    header.tag = 1000 + section;
    
    VEUIGroupModel *model = self.dataArr[section];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, header.width - 60, header.height)];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor blackColor];
    [header addSubview:titleLabel];
    
    UILabel *more = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, header.height)];
    more.maxX = header.width - titleLabel.x;
    more.text = [self.closeSections containsObject:[NSNumber numberWithInteger:section]] ? @"\U0000e910" : @"\U0000e90f";
    more.font = [UIFont VEFontWithSize:20];
    more.textColor = titleLabel.textColor;
    more.textAlignment = NSTextAlignmentRight;
    [more addToSuperView:header];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VEUIGroupModel *groupModel = self.dataArr[indexPath.section];
    VEUICellModel *cellModel = groupModel.cellArr[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VEUI_Cell"];
    cell.textLabel.text = cellModel.title;
    if (cellModel.controller) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VEUIGroupModel *groupModel = self.dataArr[indexPath.section];
    VEUICellModel *cellModel = groupModel.cellArr[indexPath.row];
    if (cellModel.controller) {
        cellModel.controller.title = cellModel.title;
        [self.navigationController pushViewController:cellModel.controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
