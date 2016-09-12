//
//  CoinViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CoinViewController.h"
#import "RecordTableViewCell.h"
#import "WithdrawViewController.h"
#import "WithdrawMoneyViewController.h"
#import "TopupViewController.h"
#import "ConsumerModel.h"
#import "LoginViewController.h"
@interface CoinViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton * _getRecordBtn;
    UIButton * _consumeRecordBtn;
    
    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
    int            type;
    
    TBActivityView *activityView;
    int            _fresh;//0 上拉；1 下拉
}

@end

@implementation CoinViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSDictionary * param=@{@"memberId":USERID};
    [RequstEngine requestHttp:@"1003" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1003-----%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            _goldNum=dic[@"member"][@"goldNum"];
        }
        
        
         [self loadUI];
    }];
}

- (void)viewDidLoad {
    
    
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    
    [super viewDidLoad];
    [self backButton];
    self.title=@"通宝币";
    self.view.backgroundColor=BGMAINCOLOR;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }

    // 加载UI
//    [self loadUI];
   
    _dataArr=[NSMutableArray arrayWithCapacity:0];
    _getCoinArr=[NSMutableArray arrayWithCapacity:0];
    _payCoinArr=[NSMutableArray arrayWithCapacity:0];
    page=1;
    firstQueryTime=@"";
    type=0;
    
 
   
    
    [self merchantsList];
   

    // Do any additional setup after loading the view.
}


-(void)loginUser
{
    LoginViewController * loginVC=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(void)merchantsList
{
    
    
    //    NSDictionary *param=@{@"isRecommend":@"",@"type":@"",@"shopName":@"",@"categoryId":@"0",@"isSupportGold":@"",@"latitude":@"0",@"longitude":@"0"};
    NSDictionary * param=@{@"type":[NSString stringWithFormat:@"%d",type]};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1031" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1031--%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        
               
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [activityView stopAnimate];
        
        if ([dic[@"errorCode"] intValue]==0) {
//            if (_fresh==1) {
//
//            }
            
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
            
            for (NSDictionary* newDic in dic[@"recordList"]) {
                MycoinModel * model=[[MycoinModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                DMLog(@"type---%@",model.type);
                if ([model.type intValue]==0) {
                    [_getCoinArr addObject:model];
                }
                else
                {
                    [_payCoinArr addObject:model];
                }
                //            DMLog(@"-----%@,%@",_getCoinArr,_payCoinArr);
            }

            [_tableView reloadData];
        }
        
        
    }];
    
}

#pragma mark - loadUI
-(void)loadUI
{
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, H(150))];
    coverView.backgroundColor=RGBACOLOR(251, 98, 7, 1);
    [self.view addSubview:coverView];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(80), H(20))];
    titleLabel.text=@"我的通宝币";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:titleLabel];
    
    _moneyLabel=[[UILabel alloc]init];
    if (_goldNum==nil) {
        _moneyLabel.text=@"0";
    }else
    {
        _moneyLabel.text=[NSString stringWithFormat:@"%.2f",[_goldNum floatValue]];
    }
    
    _moneyLabel.textColor=[UIColor whiteColor];
    _moneyLabel.font=[UIFont boldSystemFontOfSize:30];
    CGSize size =  [self sizeWithString:_moneyLabel.text font:_moneyLabel.font];
    _moneyLabel.frame = CGRectMake(W(20), kDown(titleLabel)+H(10), size.width, size.height);
    //        categorLabel.center = self.contentView.center;
    [coverView addSubview:_moneyLabel];
    
    UILabel * unitLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_moneyLabel), kDown(titleLabel)+H(20), W(50), H(20))];
    unitLabel.text=@"(个)";
    unitLabel.textColor=[UIColor whiteColor];
    unitLabel.font=[UIFont systemFontOfSize:18];
    [coverView addSubview:unitLabel];
    
    UILabel * carLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(20), kDown(_moneyLabel)+H(40), (WIDTH-W(20)*2)/2, H(20))];
//    carLabel.backgroundColor=[UIColor cyanColor];
    carLabel.textColor=[UIColor whiteColor];
    carLabel.font=[UIFont systemFontOfSize:14];
//    carLabel.text=@"车基金: 1234";
    if (_carFund==nil) {
        carLabel.text=@"车基金: 0";
    }
    else
    {
        carLabel.text=[NSString stringWithFormat:@"车基金: %@",_carFund];
    }
    
    [coverView addSubview:carLabel];
    
    UILabel * housLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(carLabel)+W(40), kDown(_moneyLabel)+H(40), W(110), H(20))];
    if (_carFund==nil) {
        housLabel.text=@"房基金: 0";
    }
    else
    {
        housLabel.text=[NSString stringWithFormat:@"房基金: %@",_houseFund];
    }
//    housLabel.text=[NSString stringWithFormat:@"房基金: %@",_houseFund];
//    housLabel.backgroundColor=[UIColor cyanColor];
    housLabel.font=[UIFont systemFontOfSize:14];
    housLabel.textColor=[UIColor whiteColor];
    [coverView addSubview:housLabel];
    
    _getRecordBtn=[UIButton buttonWithType:0];
    _getRecordBtn.frame=CGRectMake(0, kDown(coverView)+H(5), WIDTH/2, H(40));
    _getRecordBtn.backgroundColor=RGBACOLOR(247, 247, 247, 1);
    [_getRecordBtn setTitle:@"获取记录" forState:0];
    [_getRecordBtn setTitleColor:RGBACOLOR(247, 137, 0, 1) forState:0];
    _getRecordBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_getRecordBtn addTarget:self action:@selector(getMsg) forControlEvents:1<<6];
    [self.view addSubview:_getRecordBtn];
    
    _consumeRecordBtn=[UIButton buttonWithType:0];
    _consumeRecordBtn.frame=CGRectMake(WIDTH/2, kDown(coverView)+H(5), WIDTH/2, H(40));
    _consumeRecordBtn.backgroundColor=RGBACOLOR(247, 247, 247, 1);
    [_consumeRecordBtn setTitle:@"消费记录" forState:0];
    [_consumeRecordBtn setTitleColor:RGBACOLOR(84, 82, 82, 1) forState:0];
    _consumeRecordBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_consumeRecordBtn addTarget:self action:@selector(getConsumeMsg) forControlEvents:1<<6];
    [self.view addSubview:_consumeRecordBtn];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kDown(_consumeRecordBtn), WIDTH, HEIGHT-H(150)-H(40)-64-H(60)+H(5)) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=BGMAINCOLOR;
    _tableView.sectionFooterHeight=0;
    _tableView.separatorStyle=0;
    [self.view addSubview:_tableView];
    
//    UIButton * boundBtn=[UIButton buttonWithType:0];
//    boundBtn.frame=CGRectMake(W(20), kDown(_tableView)+H(10), WIDTH-W(20)*2, H(40));
//    boundBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
//    [boundBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
//    [boundBtn setTitle:@"提现" forState:0];
//    [boundBtn setTitleColor:[UIColor whiteColor] forState:0];
//    [self.view addSubview:boundBtn];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(450)+11+64, WIDTH, 1)];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [self.view addSubview:lineLabel];
    
    NSArray * arr=@[@"充值",@"提现"];
    for (int i=0; i<2; i++) {
        UIButton * button=[UIButton buttonWithType:0];
        button.frame=CGRectMake(0+i*WIDTH/2, HEIGHT-H(52), WIDTH/2, H(52));
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setTitle:arr[i] forState:0];
        button.tag=i;
        [button addTarget:self action:@selector(fuck:) forControlEvents:1<<6];
        [button setTitleColor:RGBACOLOR(255, 97, 0, 1) forState:0];
//        button.backgroundColor=RGBACOLOR(251, 250, 248, 1);
        button.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:button];
    }
    
    //上拉
    __block CoinViewController * weakSelf=self;
    __block NSMutableArray *newArr=[NSMutableArray arrayWithCapacity:0];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        
        if (type==0) {
            
            newArr=_getCoinArr;
        }if (type==1) {
            newArr=_payCoinArr;
        }
        
        //        _fresh=0;
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
        if ([totalCount intValue]==newArr.count&&[totalCount intValue]>10) {
            [weakSelf.tableView.footer endRefreshing];
            [weakSelf.tableView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [weakSelf merchantsList];
    }];
    
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        
        page=1;
        firstQueryTime=@"";
        //        _fresh=1;
        //        [weakSelf.dataArr removeAllObjects];
        [weakSelf.getCoinArr removeAllObjects];
        [weakSelf.payCoinArr removeAllObjects];
        [weakSelf merchantsList];
        
    }];

}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (type==0) {
        return _getCoinArr.count;
    }
    else
    {
        return _payCoinArr.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type==0) {
        MycoinModel * model;
        if (_getCoinArr.count>0) {
            model=_getCoinArr[indexPath.row];
        }
        RecordTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[RecordTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle=0;
        cell.headImg.image=[UIImage imageNamed:@"back_buttn"];
        cell.titleLabel.text=model.content;
//        cell.detailLabel1.text=[NSString stringWithFormat:@"%@",model.createDate];
        cell.detailLabel1.text=[NSString showTimeFormat:[NSString stringWithFormat:@"%@",model.createDate] Format:@"YYYY-MM-dd HH:mm:ss"];
        cell.moneyLabel.text=[NSString stringWithFormat:@"+ %@",model.goldNum];
        //    cell.textLabel.text=@"ygq";
        return cell;
    }
    else
    {
        MycoinModel * model;
        if (_payCoinArr.count>0) {
            model=_payCoinArr[indexPath.row];
        }
        RecordTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[RecordTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle=0;
        cell.headImg.image=[UIImage imageNamed:@"消费"];
        cell.titleLabel.text=model.content;
        cell.detailLabel1.text=[NSString showTimeFormat:[NSString stringWithFormat:@"%@",model.createDate] Format:@"YYYY-MM-dd HH:mm:ss"];

        cell.moneyLabel.text=[NSString stringWithFormat:@"- %@",model.goldNum];
        //    cell.textLabel.text=@"ygq";
        return cell;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H(50);
}
#pragma mark - 按钮绑定的方法
-(void)getMsg
{
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    type=0;
    page=1;
    firstQueryTime=@"";
    [_getRecordBtn setTitleColor:RGBACOLOR(247, 137, 0, 1) forState:0];
    [_consumeRecordBtn setTitleColor:RGBACOLOR(84, 82 , 82, 1) forState:0];
    [self merchantsList];
    [_getCoinArr removeAllObjects];
}

-(void)getConsumeMsg
{
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    type=1;
    page=1;
    firstQueryTime=@"";
    [_payCoinArr removeAllObjects];
    [_consumeRecordBtn setTitleColor:RGBACOLOR(247, 137, 0, 1) forState:0];
    [_getRecordBtn setTitleColor:RGBACOLOR(84, 82, 82, 1) forState:0];
    [self merchantsList];
}

-(void)jump
{
    WithdrawMoneyViewController * withdrawVC=[[WithdrawMoneyViewController alloc]init];
    withdrawVC.type=1;
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

-(void)fuck:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            TopupViewController * topupVC=[[TopupViewController alloc]init];
            [self.navigationController pushViewController:topupVC animated:YES];
        }
            break;
        case 1:
            
        {
            WithdrawMoneyViewController * withdrawVC=[[WithdrawMoneyViewController alloc]init];
            withdrawVC.coinCount=_goldNum;
            withdrawVC.type=1;
            withdrawVC.bankNO=_bankNo;
            [self.navigationController pushViewController:withdrawVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 自适应字体大小
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
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
