//
//  VEUITextViewCategoryViewController.m
//  VEUI_Example
//
//  Created by Coder on 2021/6/8.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEUITextViewCategoryViewController.h"

@interface VEUITextViewCategoryViewController ()<UITextViewDelegate>

@end

@implementation VEUITextViewCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(0, 200, self.view.width, 60)];
    textV.maxLength = 20;
    textV.delegate = self;
    [self.view addSubview:textV];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"==> %@", textView.text);
}

@end
