//
//  XSRMViewController.m
//  eShangBao
//
//  Created by Dev on 16/6/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "XSRMViewController.h"
#import "SYQTableViewCell.h"

@interface XSRMViewController ()
{
    NSMutableArray *titleArr;
    long           index;
    UIImageView    *selectedImage;
    
    
    NSString       *consumption;
    NSString       *partner;
    NSString       *uses;
    NSString       *withdraw;
    
    TBActivityView    *activityView;
    
}

@end

@implementation XSRMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BGMAINCOLOR;
    self.title=@"新手入门";
    index=0;
    [self createTitalView];
    [self createTableView];
    [self backButton];
    
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    [activityView startAnimate];
    
    [self requsetInfo];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)requsetInfo
{
    [RequstEngine requestHttp:@"1089" paramDic:nil blockObject:^(NSDictionary *dic) {
        
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            NSDictionary *newDic=dic[@"record"];
            
            consumption=newDic[@"consumption"];
            partner=newDic[@"partner"];
            uses=newDic[@"uses"];
            withdraw=newDic[@"withdraw"];
            
            
            [_myTableView reloadData];
            
        }
        DMLog(@"%@",dic);
        
        
    }];
}

-(void)createTableView
{
    //_myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenHeight)];
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth, KScreenHeight) style:1];
    _myTableView.backgroundColor=BGMAINCOLOR;
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    [self.view addSubview:_myTableView];
}
-(void)createTitalView
{
    NSArray *title=@[@"什么是消费宝",@"如何成为合伙人",@"通宝币有什么用",@"怎么提现"];
    titleArr=[NSMutableArray array];
    
    for (int i=0; i<4; i++) {
        
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        titleView.backgroundColor=[UIColor whiteColor];

        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth-15, 44)];
        titleLabel.text=title[i];
        titleLabel.font=[UIFont systemFontOfSize:14.];
        titleLabel.textColor=MAINCHARACTERCOLOR;
        [titleView addSubview:titleLabel];
        
        UIImageView *arrowImageView=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-31, 16, 17, 9)];
        arrowImageView.image=[UIImage imageNamed:@"arrowTop"];
        arrowImageView.tag=(i+1)*10;
        [titleView addSubview:arrowImageView];
        arrowImageView.transform=CGAffineTransformMakeRotation(M_PI);
        
        if (i==0) {
            UILabel *topline=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
            topline.backgroundColor=RGBACOLOR(225, 225, 225, 1);
            [titleView addSubview:topline];
            
            selectedImage=arrowImageView;
            selectedImage.transform=CGAffineTransformMakeRotation(0);

        }
        UIButton *myButton=[UIButton buttonWithType:0];
        myButton.frame=titleView.bounds;
        myButton.tag=i;
        [myButton addTarget:self action:@selector(myButtonClick:) forControlEvents:1<<6];
        [titleView addSubview:myButton];
        
        
        
        
                
        [titleArr addObject:titleView];
    }
}

-(void)myButtonClick:(UIButton *)sender
{
//    DMLog(@"%ld",sender.tag);
    if (sender.tag==index)return;
    
    UIView *bgView=titleArr[sender.tag];
    UIImageView *imageView=(UIImageView *)[bgView viewWithTag:(sender.tag+1)*10];
    
    imageView.transform=CGAffineTransformMakeRotation(0);
    selectedImage.transform=CGAffineTransformMakeRotation(M_PI);
    
    selectedImage=imageView;
    
    index=sender.tag;
    [_myTableView reloadData];
}


#pragma mark - tabelView 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==index) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //此处需要活动判读高度
    
    float strH;
    switch (indexPath.section) {
        case 0:
        {
            strH=[NSString calculatemySizeWithFont:12. Text:consumption width:KScreenWidth-24];
            
        }
            break;
        case 1:
        {
           strH=[NSString calculatemySizeWithFont:12. Text:partner width:KScreenWidth-24];
        }
            break;
        case 2:
        {
            strH=[NSString calculatemySizeWithFont:12. Text:uses width:KScreenWidth-24];
        }
            break;
        case 3:
        {
            strH=[NSString calculatemySizeWithFont:12. Text:withdraw width:KScreenWidth-24];
        }
            break;
            
        default:
            break;
    }
    
    return strH+24;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return titleArr[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYQTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"syqCell"];
    if (!cell) {
        
        cell=[[SYQTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"syqCell"];
    }
    //cell.isLine=YES;
    switch (indexPath.section) {
        case 0:
        {
            cell.contentStr=consumption;
        }
            break;
        case 1:
        {
            cell.contentStr=partner;
        }
            break;
        case 2:
        {
            cell.contentStr=uses;
        }
            break;
        case 3:
        {
            cell.contentStr=withdraw;
        }
            break;
            
        default:
            break;
    }
    
    cell.selectionStyle=0;
    
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
