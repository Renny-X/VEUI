//
//  VEUITextViewCategoryViewController.m
//  VEUI_Example
//
//  Created by Coder on 2021/6/8.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEUITextViewCategoryViewController.h"

@interface VEUITextViewCategoryViewController ()<UITextViewDelegate>

@property(nonatomic, strong)UITextField *tf;

@end

@implementation VEUITextViewCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(0, 200, self.view.width, 60)];
    textV.maxLength = 20;
    textV.delegate = self;
    textV.textDidChange = ^{
        NSLog(@"===> aaaaa");
    };
    [self.view addSubview:textV];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, textV.bottom + 50, textV.width, textV.height)];
    tf.placeholder = @"UITextField";
    tf.maxLength = 20;
    tf.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:tf];
    
    self.tf = tf;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"==> %@", textView.text);
    self.tf.maxLength = 12;
}

@end
