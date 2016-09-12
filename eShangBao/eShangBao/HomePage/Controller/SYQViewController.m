//
//  SYQViewController.m
//  eShangBao
//
//  Created by Dev on 16/6/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SYQViewController.h"
#import "SYQTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "SYQMoneyTableViewCell.h"
#import "PaySYQViewController.h"

@interface SYQViewController ()<UIAlertViewDelegate>
{
    NSString        *contentStr;//测试数据
    NSString        *benefitStr;
    UILabel       *numLabel;//数量
    UILabel         *allMoneyLabel;
    
    int           RGNum;//认购数量
    float         moneyNum;
    
}

@property(nonatomic,strong)NSDictionary *shareDic;

@end

@implementation SYQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"收益权";
    
    
    moneyNum=0.00;
    RGNum=1;

    
   // benefitStr=@"当发生地方都是咖啡的疯狂的身份卡上的饭看啊但还是分开后啊看电视饭卡上的饭卡获得释放卡收到回复卡戴珊反馈啊啥的看法咖色反馈啊多少分啊看电视否";
    
    [self backButton];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    
    [self createTitalView];
    [self createTableView];
    
    [self usufructInfoRequset];
    if (_usufructArr.count==0) {
        
        _usufructArr=[NSMutableArray arrayWithCapacity:0];
        [self usufructChange];
        
    }else{
        
        
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)usufructInfoRequset
{
    [RequstEngine requestHttp:@"1087" paramDic:nil blockObject:^(NSDictionary *dic) {
        
        
        
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            moneyNum=[dic[@"record"][@"price"] floatValue];
            contentStr=dic[@"record"][@"info"];
            benefitStr=dic[@"record"][@"benefit"];
            
            
            DMLog(@"%@",contentStr);
            DMLog(@"%@",benefitStr);
            
            [_myTableView reloadData];
   
            
        }
        
        
        
    }];
    
    NSDictionary *param=@{@"requestType":@"0"};
    [RequstEngine requestHttp:@"1058" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            for (NSDictionary *newDic in dic[@"dataList"]) {
                
                if ([newDic[@"name"] isEqualToString:@"LIMIT_MAC_NUM"]) {
                  
//                    NSDictionary *contentDic=newDic[@"content"];
                    _shareDic=newDic;
                    
                }
            }

            
            
        }
        
        
        
        
    }];

}

-(void)usufructChange
{
    
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    DMLog(@"---当前的时间的字符串 =%@",currentDateStr);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:-6];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *beforDate = [dateFormatter stringFromDate:newdate];
    DMLog(@"---前7天=%@",beforDate);
    
    NSDictionary *param=@{@"startDate":beforDate,@"endDate":currentDateStr};
    [RequstEngine requestHttp:@"1085" paramDic:param blockObject:^(NSDictionary *dic) {
        
        
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            
            for (NSDictionary *newDic in dic[@"recordList"]) {
                UsufructModel *model=[[UsufructModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_usufructArr addObject:model];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
            //[_myTableView reloadRowsAtIndexPaths:indexSet withRowAnimation:UITableViewRowAnimationTop];
            [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
        }
        
    }];
}


-(void)createTitalView
{
    NSArray *titalArr=@[@"项目介绍",@"项目收益",@"认购金额",@"受益权走势图"];
    titalViewArr=[NSMutableArray array];
    for (int i=0;i<4; i++) {
        
        UIView *titalView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 33)];
        titalView.backgroundColor=RGBACOLOR(249, 249, 249, 1);
        
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, H(2), 33)];
        lineLabel.backgroundColor=RGBACOLOR(247, 137, 0, 1);
        [titalView addSubview:lineLabel];
        
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 6, W(100), H(20))];
        titleLabel.text=titalArr[i];
        titleLabel.font=[UIFont systemFontOfSize:12];
        titleLabel.textColor=GRAYCOLOR;
        [titalView addSubview:titleLabel];
        [titalViewArr addObject:titalView];
    }
}


-(void)createTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _myTableView.dataSource=self;
    _myTableView.delegate=self;
    _myTableView.separatorStyle=0;
    [self.view addSubview:_myTableView];
    
    UIView *titalView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, W(120))];
    UIImageView *titalImage=[[UIImageView alloc]initWithFrame:titalView.bounds];
    titalImage.image=[UIImage imageNamed:@"income"];
    [titalView addSubview:titalImage];
    _myTableView.tableHeaderView=titalView;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {

            return (contentStr.length==0)?0:1;
            
        }
            break;
        case 1:
        {
            return (benefitStr.length==0)?0:1;
        }
            break;
        case 2:
        {
            return 1;
        }
            break;
        case 3:
        {
            
            return 1;
        }
            break;
            
            
        default:
            break;
    }
 
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return titalViewArr[section];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==3) {
        return 0;
    }
    return 33.;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        return 203;
    }
    if (indexPath.section==2) {
        return 50;
    }
    if (indexPath.section==0) {
        
        float strH=[NSString calculatemySizeWithFont:12. Text:contentStr width:KScreenWidth-24]+24;
        return strH;
    }
    if(indexPath.section==1){
       
        float strH1=[NSString calculatemySizeWithFont:12. Text:benefitStr width:KScreenWidth-24]+24;
        return strH1;
    }
    
    return 0;
    
   // return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        
        RecommendTableViewCell * cell=[RecommendTableViewCell nowStatusWithTableView:_myTableView section:indexPath.section cellForRowAtIndexPath:indexPath];
        cell.selectionStyle=0;
        cell.layer.masksToBounds=YES;
        cell.type=1;
        
        if (_usufructArr.count>0) {
            cell.dataArr=_usufructArr;
        }
        
        
        return cell;
    }
    if (indexPath.section==2) {
        
        SYQMoneyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"moneyCell"];
        if (!cell) {
            
            cell=[[[NSBundle mainBundle] loadNibNamed:@"SYQMoneyTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.add.tag=10;
        cell.reduction.tag=11;
        cell.confirmBtn.tag=12;
        
        [cell.add addTarget:self action:@selector(ButtonClick:) forControlEvents:1<<6];
        [cell.reduction addTarget:self action:@selector(ButtonClick:) forControlEvents:1<<6];
        numLabel= cell.numLabel;
        allMoneyLabel=cell.moneyLabel;
        
        cell.numLabel.text=[NSString stringWithFormat:@"%d",RGNum];
        cell.moneyLabel.text=[NSString stringWithFormat:@"¥%.2f",moneyNum*RGNum];
        
        [cell.confirmBtn addTarget:self action:@selector(ButtonClick:) forControlEvents:1<<6];
        cell.selectionStyle=0;
        return cell;
        
    }

    SYQTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"syqCell"];
    if (!cell) {
        
        cell=[[SYQTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"syqCell"];
    }
    if (indexPath.section==0) {
        
        
        cell.contentStr=contentStr;
        //cell.textView.text=contentStr;
        

        
        
        
    }else{
        
        
        cell.contentStr=benefitStr;
        //cell.textView.text=benefitStr;
        
    }
    cell.selectionStyle=0;
    return cell;
//    cell.selectionStyle=0;
//    return cell;
}

#pragma mark  - 认购金额方法操作
-(void)ButtonClick:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 10:
        {
            if (RGNum<[_shareDic[@"content"] intValue]) {
                RGNum++;
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"认购数量最多为20" buttonTitle:nil];
            }
            
            DMLog(@"加数量");

            
        }
            break;
        case 11:
        {
            RGNum--;
            if (RGNum==0) {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"认购数量不能为0" buttonTitle:nil];
                RGNum=1;
                return;
            }

        }
            break;
        case 12:
        {
            DMLog(@"确认认购");
            
            if (![NSString isLogin]) {
                [self loginUser];
                
            }else{
                
                NSString *msgStr=[NSString stringWithFormat:@"是否确认购买%d份收益权",RGNum];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:msgStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alertView show];

                
            }
            
        }
            break;
            
        default:
            break;
    }
    
    numLabel.text=[NSString stringWithFormat:@"%d",RGNum];
    allMoneyLabel.text=[NSString stringWithFormat:@"¥%.2f",moneyNum*RGNum];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            NSDictionary * param=@{@"num":[NSString stringWithFormat:@"%d",RGNum],@"payMethod":@"0"};
            [RequstEngine requestHttp:@"1083" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1083----%@",dic);
                if ([dic[@"errorCode"] intValue]==0) {
            
                    PaySYQViewController * payVC=[[PaySYQViewController alloc]init];
                    payVC.rgNum=[NSString stringWithFormat:@"%d",RGNum];
                    [self.navigationController pushViewController:payVC animated:YES];
                }
                else
                {
                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                }
            }];
    
            return;
        }
            break;
            
        default:
            break;
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
