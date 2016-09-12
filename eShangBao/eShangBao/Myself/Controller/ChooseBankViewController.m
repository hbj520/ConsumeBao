//
//  ChooseBankViewController.m
//  eShangBao
//
//  Created by doumee on 16/7/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ChooseBankViewController.h"

@interface ChooseBankViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSArray     * _titleNameArray;
}


@end

@implementation ChooseBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择银行卡";
    [self backButton];
    
    _titleNameArray=[NSArray arrayWithObjects:@"中国工商银行",@"中国银行",@"中国农业银行",@"上海浦发银行",@"中国人民银行",@"中国交通银行",@"中国民生银行",@"中国光大银行",@"招商银行",@"中国信托商业银行",@"中国邮政银行",@"中国农业发展银行",@"中国发展银行",@"华夏银行",@"中信实业银行",@"上海浦东发展银行",@"兴业银行",@"徽商银行",nil];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.rowHeight=44;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleNameArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text=_titleNameArray[indexPath.row];
    cell.textLabel.textColor=MAINCHARACTERCOLOR;
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, WIDTH, 1)];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [cell.contentView addSubview:lineLabel];
    
    cell.selectionStyle=0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _block(_titleNameArray[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
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
