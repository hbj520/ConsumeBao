
//
//  FillStoreMsgViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/23.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "FillStoreMsgViewController.h"

@interface FillStoreMsgViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}

@end

@implementation FillStoreMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"填写店铺信息";
    self.view.backgroundColor=BGMAINCOLOR;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, H(10), WIDTH, H(40)*2) style:0];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.scrollEnabled=NO;
    _tableView.separatorStyle=0;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=0;
    cell.accessoryType=1;
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
    if (indexPath.row==0) {
        cell.textLabel.text=@"门店首图";
        cell.detailTextLabel.text=@"幼稚菜品或者是门店照片";
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"店铺照片";
        cell.detailTextLabel.text=@"请选择";
    }
    return cell;
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
