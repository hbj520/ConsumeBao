//
//  AdvertisingViewController.m
//  eShangBao
//
//  Created by Dev on 16/3/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "AdvertisingViewController.h"

@interface AdvertisingViewController ()

@end

@implementation AdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    if (_add==0) {
        self.title=_adModel.title;
        UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
        webView.backgroundColor=BGMAINCOLOR;
        [self.view addSubview:webView];
        
        if ([_adModel.isLink intValue]==0) {
            [webView loadHTMLString:_adModel.content baseURL:nil];
        }else{
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_adModel.content]]];
        }

    }
    else
    {
        self.title=_acModel.title;
        UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
        webView.backgroundColor=BGMAINCOLOR;
        [self.view addSubview:webView];
        
        if ([_acModel.isLink intValue]==0) {
            [webView loadHTMLString:_acModel.content baseURL:nil];
        }else{
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_acModel.content]]];
        }

    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
