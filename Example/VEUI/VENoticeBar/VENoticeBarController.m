//
//  VENoticeBarController.m
//  VEUI_Example
//
//  Created by Coder on 2021/3/10.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VENoticeBarController.h"

@interface VENoticeBarController ()

@end

@implementation VENoticeBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    VENoticeBar *notice = [[VENoticeBar alloc] initWithStyle:VENoticeBarStyleInfo info:@"这里是info字符串"];
    
    notice.iconString = @"\U0000e92d";
    
    [notice layoutWithWidth:self.view.width];
    [self.view addSubview:notice];
}

@end
