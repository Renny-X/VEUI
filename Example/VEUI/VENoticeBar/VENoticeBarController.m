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
    notice.y = 100;
    [notice layoutWithWidth:self.view.width];
    [self.view addSubview:notice];
    
//    [notice show];
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
