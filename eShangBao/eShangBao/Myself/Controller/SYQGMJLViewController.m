//
//  SYQGMJLViewController.m
//  eShangBao
//
//  Created by Dev on 16/7/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SYQGMJLViewController.h"
#import "SYQJLTableViewCell.h"
#import "SYQViewController.h"
#import "SYQFHViewController.h"
#import "ConsumerModel.h"
@interface SYQGMJLViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString * _totalNum;
    
    UILabel  * _syqfeLable;
    
    TBActivityView * activityView;
}

@property(nonatomic,strong)NSMutableArray * listArr;
@end

@implementation SYQGMJLViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];

    [_listArr removeAllObjects];
    [self merCharList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"收益权";
    _listArr=[NSMutableArray arrayWithCapacity:0];
    [self backButton];
    // Do any additional setup after loading the view.
    [self createTableView];
    [self createListRequset];
    
    
    
    UIButton *rightButton1=[UIButton buttonWithType:0];
    rightButton1.frame=CGRectMake(0, 0, 50, 14);
    rightButton1.titleLabel.font=[UIFont systemFontOfSize:14.];
    [rightButton1 setTitleColor:[UIColor whiteColor] forState:0];
    [rightButton1 setTitle:@"去购买" forState:0];
    [rightButton1 addTarget:self action:@selector(rightButtonClick) forControlEvents:1<<6];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithCustomView:rightButton1];
    self.navigationItem.rightBarButtonItem=rightButton;
    
}

-(void)merCharList
{
    [RequstEngine requestHttp:@"1090" paramDic:nil blockObject:^(NSDictionary *dic) {
        DMLog(@"1090----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            _totalNum=dic[@"totalNum"];
            _syqfeLable.text=[NSString stringWithFormat:@"%@",_totalNum];
            for (NSDictionary * newDic in dic[@"record"]) {
                PurchaseProfitModel * model=[[PurchaseProfitModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_listArr addObject:model];
                
            }
            
            [_myTabelView reloadData];
        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
    }];
}

-(void)createTableView
{
    
    _myTabelView=[[UITableView alloc]initWithFrame:self.view.bounds];
    _myTabelView.dataSource=self;
    _myTabelView.delegate=self;
    _myTabelView.separatorStyle=0;
    [self.view addSubview:_myTabelView];
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
    titleView.backgroundColor=[UIColor whiteColor];
    
    UILabel *syqLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, KScreenWidth, 18)];
    syqLable.text=@"收益权份额";
    syqLable.font=[UIFont systemFontOfSize:18];
    syqLable.textColor=MAINCHARACTERCOLOR;
    syqLable.textAlignment=1;
    [titleView addSubview:syqLable];
    
    _syqfeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(syqLable.frame)+18, KScreenWidth, 33)];
    _syqfeLable.text=@"0份";
    _syqfeLable.font=[UIFont systemFontOfSize:33];
    _syqfeLable.textColor=MAINCOLOR;
    _syqfeLable.textAlignment=1;
    [titleView addSubview:_syqfeLable];
    
    UIButton *lookInfoBtn=[UIButton buttonWithType:0];
    [lookInfoBtn setTitle:@"查看分红" forState:0];
    lookInfoBtn.frame=CGRectMake(KScreenWidth/2.-50, CGRectGetMaxY(_syqfeLable.frame)+15, 100, 30);
    lookInfoBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [lookInfoBtn setTitleColor:GRAYCOLOR forState:0];
    [lookInfoBtn addTarget:self action:@selector(lookInfoBtn) forControlEvents:1<<6];
    lookInfoBtn.layer.borderWidth=1;
    lookInfoBtn.layer.borderColor=BGMAINCOLOR.CGColor;
    [titleView addSubview:lookInfoBtn];
    
    _myTabelView.tableHeaderView=titleView;
}


-(void)createListRequset
{
    
    
    
    
}
#pragma mark - tabelViewDelegate & dataSource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    title.text=@"     购买记录";
    title.backgroundColor=BGMAINCOLOR;
    title.font=[UIFont systemFontOfSize:14.];
    title.textColor=GRAYCOLOR;
    return title;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PurchaseProfitModel * model;
    if (_listArr.count>0) {
        model=_listArr[indexPath.row];
    }
    SYQJLTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"syqjlCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SYQJLTableViewCell" owner:nil options:nil] firstObject];
        
    }
    cell.infoModel=model;
//    cell.gmNum.text=[NSString stringWithFormat:@"购买数量：%@",model.num];
    
    cell.selectionStyle=0;
    return cell;
}

#pragma mark - 方法
-(void)rightButtonClick
{
  
    SYQViewController *syqViewC=[[SYQViewController alloc]init];
    [self.navigationController pushViewController:syqViewC animated:YES];

    

}

-(void)lookInfoBtn
{
    DMLog(@"你跳啊。。。");
    if ([_totalNum intValue]==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"您还没有购买收益权，请先购买！" buttonTitle:nil];
    }
    else
    {
        SYQFHViewController *syqViewC=[[SYQFHViewController alloc]init];
        [self.navigationController pushViewController:syqViewC animated:YES];
    }
   
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
