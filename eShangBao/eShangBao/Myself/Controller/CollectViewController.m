//
//  CollectViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/18.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectTableViewCell.h"
#import "ManageOrderTableViewCell.h"
#import "ConsumerModel.h"
#import "StoreInfoViewController.h"
#import "LoginViewController.h"
#import "LMSJTableViewCell.h"
#import "SJXQViewController.h"

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
    NSMutableArray * _nearArr;
    
    NSString       *firstQueryTime1;
    NSString       *totalCount1;
    int            page1;
    NSMutableArray * _nearArr1;

    
    TBActivityView *activityView;
    int            _fresh;//0 上拉；1 下拉
    
    
    int            _chooseType;//0 超市 1 商家
    
}

@property(nonatomic,strong)UIButton *selectedBtn;

@end

@implementation CollectViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _fresh=1;
    page=1;
    firstQueryTime=@"";
    [self merchantsList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"我的收藏";
    self.view.backgroundColor=[UIColor whiteColor];
    
    _chooseType=1;
    
    [self createChooseButton];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    [self.view addSubview:_tableView];
    
    _dataArr=[NSMutableArray arrayWithCapacity:0];
    _nearArr=[NSMutableArray arrayWithCapacity:0];
    page=1;
    firstQueryTime=@"";
    
   
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];

    //上拉
    __block CollectViewController * weakSelf=self;
    [_tableView addLegendFooterWithRefreshingBlock:^{
        
        _fresh=0;
        if ([totalCount intValue]==0) {
            
            [weakSelf.tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [weakSelf.tableView.footer endRefreshing];
            
            return ;
        }
        if ([totalCount intValue]>0&&[totalCount intValue]<=10) {
            [weakSelf.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [weakSelf.tableView.footer endRefreshing];
            return ;
        }
        if ([totalCount intValue]==_nearArr.count&&[totalCount intValue]>10) {
            [weakSelf.tableView.footer endRefreshing];
            [weakSelf.tableView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [weakSelf merchantsList];
    }];
    
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        _fresh=1;
        page=1;
        firstQueryTime=@"";
//        [weakSelf.nearArr removeAllObjects];
        [weakSelf merchantsList];
        
    }];

    // Do any additional setup after loading the view.
}

-(void)createChooseButton
{
//    UIView *chooseView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40)];
//    chooseView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:chooseView];
//    
//    NSArray *btnStrArr=@[@"联营超市",@"联盟商家"];
//    
//    for (int i=0; i<2; i++) {
//        
//        UIButton *chooseButton1=[UIButton buttonWithType:0];
//        chooseButton1.frame=CGRectMake(i*(KScreenWidth/2.+1), 0, KScreenWidth/2., 40);
//        [chooseButton1 setTitle:btnStrArr[i] forState:0];
//        [chooseButton1 setTitleColor:MAINCHARACTERCOLOR forState:0];
//        [chooseButton1 addTarget:self action:@selector(chooseButtonClick:) forControlEvents:1<<6];
//        chooseButton1.tag=i;
//        if (i==0) {
//            _selectedBtn=chooseButton1;
//            [chooseButton1 setTitleColor:MAINCOLOR forState:0];
//        }
//        chooseButton1.titleLabel.font=[UIFont systemFontOfSize:14.];
//        [chooseView addSubview:chooseButton1];
//    }
//    
//    UILabel *bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenWidth, 1)];
//    bottomLabel.backgroundColor=BGMAINCOLOR;
//    [chooseView addSubview:bottomLabel];
    
}

-(void)chooseButtonClick:(UIButton *)sender
{
    
    _chooseType=(int)sender.tag;
    if (_selectedBtn!=sender) {
        
        
        [sender setTitleColor:MAINCOLOR forState:0];
        [_selectedBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        _selectedBtn=sender;
        //[_nearArr removeAllObjects];
        _fresh=1;
        page=1;
        firstQueryTime=@"";
        [self merchantsList];
        
    }
    
//    DMLog(@"sda");
//    switch (sender.tag) {
//        case 0:
//        {
//            _chooseType=0;
//        }
//            break;
//        case 1:
//        {
//            _c
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    
    
    
}


-(void)merchantsList
{
    
    NSDictionary *param=@{@"type":@"0",@"isShop":[NSString stringWithFormat:@"%d",_chooseType]};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1053" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1053--%@",dic);
        
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            if (_fresh==1) {
                [_nearArr removeAllObjects];
            }
            if ([dic[@"totalCount"] intValue]==0) {
                [self.tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"recordList"];
            if (newDic.count>0) {
                page++;
            }
            firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];
            //
            
            for (NSDictionary *myDic in dic[@"recordList"]) { 
                MycollectModel * model=[[MycollectModel alloc]init];
                [model setValuesForKeysWithDictionary:myDic];
                [_nearArr addObject:model];
            }
            
            [_tableView reloadData];
        }
        
        
    }];
    
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_chooseType==1) {
        
        
        
        MycollectModel *model=_nearArr[indexPath.row];
        LMSJTableViewCell *lmsjCell=[tableView dequeueReusableCellWithIdentifier:@"lmsjCell"];
        if (!lmsjCell) {
            
            lmsjCell=[[[NSBundle mainBundle] loadNibNamed:@"LMSJTableViewCell" owner:nil options:nil] firstObject];
        }
        lmsjCell.cancelButton.hidden=NO;
        [lmsjCell.cancelButton addTarget:self action:@selector(collectGoods:) forControlEvents:1<<6];
        lmsjCell.collectModel=model;
        lmsjCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return lmsjCell;
        
    }
    
    
    
    MycollectModel * model;
    if (_nearArr.count>0) {
        model=_nearArr[indexPath.row];
    }
    ManageOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"collectCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ManageOrderTableViewCell" owner:nil options:nil] objectAtIndex:1];
    }
    [cell.collectBtn addTarget:self action:@selector(collectGoods:) forControlEvents:1<<6];
    cell.storeName.text=(model.branchName.length==0)?model.shopName:[NSString stringWithFormat:@"%@(%@)",model.shopName,model.branchName];
    cell.monthNum.text=[NSString stringWithFormat:@"月销量%@",model.monthOrderNum];
    cell.startNum.text=[NSString stringWithFormat:@"起送价￥%@|配送￥%@",model.startSendPrice,model.sendPrice];
    cell.destinationAddress.text=model.shopAddr;
    cell.collectIdLabel.text=model.collectId;
    cell.selectionStyle=0;
    [cell.headImg setImageWithURLString:model.doorImg placeholderImage:DEFAULTIMAGE];
    int starNum=[model.score intValue];
    cell.starImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05",starNum]];
    cell.userAddress.text=model.shopAddr;
    if (model.shopAddr.length==0) {
        cell.shopAddImg.hidden=YES;
    }
    else
    {
        cell.shopAddImg.hidden=NO;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_chooseType==0) {
        
        return 85;
    }else{
        return 95;
    }
    //return 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MycollectModel * model=_nearArr[indexPath.row];
    
    
    if (model.objectId.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"找不到该商家了" buttonTitle:nil];
        return;
    }
    if (_chooseType==1) {
        
        
        SJXQViewController *SJXQView=[[SJXQViewController alloc]init];
        SJXQView.shopID=model.objectId;
        [self.navigationController pushViewController:SJXQView animated:YES];
        return;
    }
    else
    {
        StoreInfoViewController * storeVC=[[StoreInfoViewController alloc]init];
        storeVC.shopID=model.objectId;
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    
}
#pragma mark - 按钮绑定的方法

-(void)cancelButtonClick
{
    DMLog(@"取消收藏");
}


-(void)collectGoods:(id)sender
{
    DMLog(@"取消收藏");
//    DMLog(@"tag---%ld",sender.tag);
    
    ManageOrderTableViewCell * cell = (ManageOrderTableViewCell *)[[[sender superview] superview]superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    MycollectModel * model=_nearArr[path.row];
    DMLog(@"collectID---%@",model.collectId);
//    NSDictionary * param=@{@"cellectId":[NSString stringWithFormat:@"%ld",sender.tag]};
    NSDictionary * param=@{@"objectId":model.objectId};
    [RequstEngine requestHttp:@"1051" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1051--%@",dic);
        DMLog(@"error--%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==00000) {
             [UIAlertView alertWithTitle:@"温馨提示" message:@"已成功取消收藏" buttonTitle:nil];
            page=1;
            firstQueryTime=@"";
            [_nearArr removeAllObjects];
            [self merchantsList];
            [_tableView reloadData];
        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
       
    }];
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
