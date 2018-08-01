//
//  ViewController.m
//  TPFontSize
//
//  Created by carnet on 2018/8/1.
//  Copyright © 2018年 TP. All rights reserved.
//

#import "ViewController.h"
#import "AdjustmentFontSizeView.h"
#import <WebKit/WebKit.h>
@interface ViewController ()
@property (nonatomic,strong) AdjustmentFontSizeView *adFontSizeView;
@property (nonatomic,strong) WKWebView *webview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_webview];
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://jianshu.com"]]];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(setFontSize) forControlEvents:UIControlEventTouchUpInside];
    
    _adFontSizeView = [AdjustmentFontSizeView AdjustmentFontSize:self.view heightTop:64];
}
//调整字体大小
- (void)setFontSize{
    [_adFontSizeView showView];
    [_adFontSizeView setCallback:^(NSInteger index) {
        NSLog(@"调整字体大小");
    }];
}
@end
