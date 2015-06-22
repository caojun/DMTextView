//
//  ViewController.m
//  DMTextViewDemo
//
//  Created by Dream on 15/6/22.
//  Copyright (c) 2015年 GoSing. All rights reserved.
//

#import "ViewController.h"
#import "DMTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y = 0;
    frame.origin.x = 20;
    frame.size.width -= frame.origin.x * 2;
    frame.size.height = 80;
    DMTextView *textView = [[DMTextView alloc] initWithFrame:frame];
    textView.placeholder = @"请输入40个字符!";
    [self.view addSubview:textView];
    
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 8;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 0.5;
    
//    textView.placeholderColor = [UIColor redColor];
    textView.font = [UIFont systemFontOfSize:20];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
