//
//  VEBubbleViewController.m
//  VEUI_Example
//
//  Created by Coder on 2021/9/22.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEBubbleViewController.h"

@interface VEBubbleViewController ()

@end

@implementation VEBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VEBubbleView *bubble = [[VEBubbleView alloc] initWithFrame:CGRectMake(100, 100, 300, 200)];
    bubble.arrowSize = CGSizeMake(30, 20);
    bubble.contentColor = [UIColor linerColorWithColors:@[UIColor.greenColor, UIColor.redColor] startPoint:CGPointZero endPoint:CGPointMake(1, 0) colorSize:bubble.size locations:nil];
    
    [self.view addSubview:bubble];
}

@end
