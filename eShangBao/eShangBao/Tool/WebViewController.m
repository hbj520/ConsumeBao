//
//  WebViewController.m
//  eShangBao
//
//  Created by doumee on 16/5/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    DMLog(@"+++++%@",_content);
    //self.title=@"服用后悔药的禁忌";
//    _time=0;
    self.view.backgroundColor=BGMAINCOLOR;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //webView的内容待处理
    UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.backgroundColor=BGMAINCOLOR;
    [self.view addSubview:webView];
    
    [webView loadHTMLString:_content baseURL:nil];
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
