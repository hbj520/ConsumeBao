//
//  OrderDetailViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/26.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderInfoTableViewCell.h"
#import "OrderDetaileTableViewCell.h"
#import "StoreInfoViewController.h"
#import "OrderDataModel.h"
#import "CategoryViewController.h"
#import "SJXQViewController.h"
@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    UITableView    * _stateTableView;//显示状态的Table
    UITableView    * _detailTableView;//显示详情的Table
    UIScrollView   * _mainScrollView;
    int            currentX;//标示当前的Table
    OrderInfoModel *infoModel;
    int            oneSectionNum;//第一个区的个数
    double         totalMoney;//总价钱
    
    UIView * _coverView;
    UIView * _backView;
    UIButton * _sendBtn;//发货按钮
    UIButton * _receiveBtn;//接单按钮
    UIButton * _refuseBtn;//拒绝按钮
}

@property(nonatomic,strong)UIButton        *selectedBtn;
@property(nonatomic,strong)NSMutableArray  *labelArr;
@property(nonatomic,strong)NSArray         *cellLableArr;
@property(nonatomic,strong)NSMutableArray  *chooseGoodsListArr;//订单商品

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    
    DMLog(@"orderID---%@",_orderID);
    [super viewDidLoad];
    [self backButton];
    self.title=@"订单详情";
    self.view.backgroundColor=BGMAINCOLOR;
    [self backButton];
    
    _labelArr=[NSMutableArray arrayWithCapacity:0];
    _chooseGoodsListArr=[NSMutableArray arrayWithCapacity:0];
    
    [self createLabelVeiw];
    _selectedBtn=(UIButton *)[self.view viewWithTag:1];
    _cellLableArr=@[@"订单号码",@"订单时间",@"支付方式"];
    [self createTabelView];
    [self requsteMyOrder];
    
    infoModel=[[OrderInfoModel alloc]init];
    
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"phoneBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    
}
#pragma mark - 构建我的订单状态
-(void)requsteMyOrder
{
    NSDictionary *param=@{@"orderId":_orderID};
    [RequstEngine requestHttp:@"1020" paramDic:param blockObject:^(NSDictionary *dic) {

        DMLog(@"1020----%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            [infoModel setValuesForKeysWithDictionary:dic[@"goodsOrder"]];
        }
        oneSectionNum=(int)infoModel.goodsList.count+4;
        for (NSDictionary *newDic in infoModel.goodsList) {
            
            OrderGoodsList *model=[[OrderGoodsList alloc]init];
            [model setValuesForKeysWithDictionary:newDic];
            [_chooseGoodsListArr addObject:model];
        }
        [_stateTableView reloadData];
        [_detailTableView reloadData];
        
        if (_type==1) {
            
            if ([dic[@"goodsOrder"][@"status"] intValue]==2) {
                [_backView removeFromSuperview];
                _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-H(50), WIDTH, H(50))];
                _coverView.backgroundColor=[UIColor whiteColor];
                [self.view addSubview:_coverView];
                
                _sendBtn=[UIButton buttonWithType:0];
                _sendBtn.layer.cornerRadius=3;
                _sendBtn.layer.masksToBounds=YES;
                _sendBtn.frame=CGRectMake(W(20), H(5), WIDTH-W(20)*2, H(40));
                _sendBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
                [_sendBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
                [_sendBtn setTitle:@"确认发货" forState:0];
                [_sendBtn setTitleColor:[UIColor whiteColor] forState:0];
                [_coverView addSubview:_sendBtn];
            }
           else if ([dic[@"goodsOrder"][@"status"] intValue]==1) {
                _backView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-H(50), WIDTH, H(50))];
                _backView.backgroundColor=[UIColor whiteColor];
                [self.view addSubview:_backView];
                
                NSArray * arr=@[@"确认接单",@"拒绝接单"];
                for (int i=0; i<2; i++) {
                    UIButton * button=[UIButton buttonWithType:0];
                    button.frame=CGRectMake(0+i*WIDTH/2, H(0), WIDTH/2, H(50));
                    [button setTitle:arr[i] forState:0];
                    button.tag=i;
                    [button addTarget:self action:@selector(fuck:) forControlEvents:1<<6];
                    [button setTitleColor:RGBACOLOR(255, 97, 0, 1) forState:0];
                    button.backgroundColor=RGBACOLOR(251, 250, 248, 1);
                    [_backView addSubview:button];
                }
                
            }
            else
            {
                [_coverView removeFromSuperview];
                [_backView removeFromSuperview];
                
            }
            
        }
    }];
    
    

}

-(void)rightBtnClick
{
    if (infoModel.shopId.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"直营超市暂未开通电话功能" buttonTitle:nil];
    }
    else
    {
        DMLog(@"打电话");
        if (_whichType==0) {
            if (infoModel.shopMobile.length==0) {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"暂无电话" buttonTitle:nil];
            }
            else
            {
                NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",infoModel.shopMobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];

            }
        }
        else
        {
            NSString * phoneStr=infoModel.addr[@"phone"];
            
            if (phoneStr.length==0) {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"暂无电话" buttonTitle:nil];
            }
            else
            {
                NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",infoModel.addr[@"phone"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];

            }
        }
        

    }
}
-(void)createLabelVeiw
{
    NSArray *labelTitle=@[@"  订单详情",@"  配送信息",@"  订单信息"];
    for (int i=0; i<3; i++) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=MAINCHARACTERCOLOR;
        label.backgroundColor=BGMAINCOLOR;
        label.text=labelTitle[i];
        [_labelArr addObject:label];
    }
}
-(void)createTabelView
{
    _tabelScrollView.contentSize=CGSizeMake(WIDTH*2, 0);
    _tabelScrollView.showsHorizontalScrollIndicator=NO;
    _tabelScrollView.showsVerticalScrollIndicator=NO;
    _tabelScrollView.bounces=NO;
    _tabelScrollView.pagingEnabled=YES;
    
    _stateTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-H(50)) style:0];
    _stateTableView.delegate=self;
    _stateTableView.dataSource=self;
    _stateTableView.separatorStyle=0;
    _stateTableView.tag=1;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [_tabelScrollView addSubview:_stateTableView];
    _stateTableView.backgroundColor=[UIColor clearColor];
    
    
    _detailTableView=[[UITableView alloc]initWithFrame:CGRectMake(KScreenWidth, 0, WIDTH, HEIGHT-H(50)-45-64) style:0];
    _detailTableView.delegate=self;
    _detailTableView.dataSource=self;
    _detailTableView.separatorStyle=0;
    _detailTableView.tag=2;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [_tabelScrollView addSubview:_detailTableView];
    _detailTableView.backgroundColor=[UIColor clearColor];

    
}
#pragma mark TableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return _labelArr[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==2) {
        
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row==0) {
                    return 40;
                }
                return 35;
            }
                break;
            case 1:
            {
                if (indexPath.row==1) {
                    
                    float rowHigh=[NSString calculatemySizeWithFont:14 Text:infoModel.addr[@"addrFull"] width:KScreenWidth-90];
                    return 75+rowHigh-17;
                }
                return 35;
            }
                break;
            case 2:
            {
                return 35;
            }
                break;
                
            default:
                break;
        }
    }
    
    if (tableView.tag==1) {
//#warning 此处的高度判断需拿到状态才能确定
        //0未付款，1:已付款 2:商家已确认 3:商家拒接 4:已发货 5:已收货 6:买家取消


//        if ([infoModel.status intValue]==0||[infoModel.status intValue]==1) {
//            return 70;
//        }
        if ([infoModel.status intValue]==2&&indexPath.row==0) {
            
            return 90;
        }
        if ([infoModel.status intValue]==4&&(indexPath.row==0||indexPath.row==1)) {
            
            return 90;
            
        }
        
        if ([infoModel.status intValue]==5&&(indexPath.row==1||indexPath.row==2)) {
            return 90;
        }

        
        return 70;
    }
    
    
    
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==1) {
        return 1;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==2) {
        return 30;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==2) {
        
        switch (section) {
            case 0:
            {

                return oneSectionNum;
            }
                break;
            case 1:
            {
                return 2;
            }
                break;
            case 2:
            {
                return 4;
            }
                break;
            default:
                break;
        }
        
    }
    
    //0未付款，1:已付款 2:商家已确认 3:商家拒接 4:已发货 5:已收货 6:买家取消
    //做4类状态判断
    int  status=[infoModel.status intValue];
    switch (status) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            return 2;
        }
            break;
        case 2:
        {
            return 3;
        }
            break;
        case 3:
        {
            return 2;
        }
            break;
        case 4:
        {
            return 3;
        }
            break;
        case 5:
        {
            return 5;
        }
            break;
        case 6:
        {
            return 2;
        }
            break;
            
        default:
            break;
    }
    
    
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *arrCell=[[NSBundle mainBundle] loadNibNamed:@"OrderInfoTableViewCell" owner:nil options:nil];
    NSArray *orderType=[[NSBundle mainBundle] loadNibNamed:@"OrderDetaileTableViewCell" owner:nil options:nil];
    
    if (tableView.tag==2) {
        OrderInfoTableViewCell *cell=[[OrderInfoTableViewCell alloc]init];
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row==0) {
                    
                    
                    cell=[arrCell objectAtIndex:0];
                    [cell.storeInfoBtn addTarget:self action:@selector(storeInfoBtnClick) forControlEvents:1<<6];
                    if (infoModel.shopName.length==0&&infoModel.branchName.length!=0) {
                        cell.storeName.text=[NSString stringWithFormat:@"%@",infoModel.branchName];
                    }
                    else if (infoModel.shopName.length!=0&&infoModel.branchName.length==0)
                    {
                        cell.storeName.text=[NSString stringWithFormat:@"%@",infoModel.shopName];
                    }
                    else if (infoModel.shopName.length!=0&&infoModel.branchName.length!=0)
                    {
                        cell.storeName.text=[NSString stringWithFormat:@"%@(%@)",infoModel.shopName,infoModel.branchName];
                    }
                    else
                    {
//                        if (infoModel.shopId.length==0) {
//                            cell.storeName.text=@"消费宝直营超市";
//                        }
                        if ([_orderType intValue]==2) {
                            cell.storeName.text=@"合伙人商品";
                        }
                        
                    }
                    
                }

                if (indexPath.row>0&&indexPath.row<oneSectionNum-3) {
                    
                    OrderGoodsList *model=_chooseGoodsListArr[indexPath.row-1];
                    cell=[arrCell objectAtIndex:1];
                    cell.goodsName.text=model.goodsName;
                    cell.goodsNum.text=[NSString stringWithFormat:@"¥%.2fx%@",[model.goodsPrice floatValue],model.goodsNum];
                    double price=[model.goodsPrice doubleValue];
                    double number=[model.goodsNum doubleValue];
                    double totalNum=price*number;
                    cell.goodsPrice.text=[NSString stringWithFormat:@"¥%.2f",totalNum];
                }

                if (indexPath.row==oneSectionNum-3) {
                    
                    cell=[arrCell objectAtIndex:2];
                    cell.distributionNum.text=[NSString stringWithFormat:@"¥%@",infoModel.sendPrice];
                }
                if (indexPath.row==oneSectionNum-2) {
                    
                    cell=[arrCell objectAtIndex:3];
                    cell.vouchersNum.text=[NSString stringWithFormat:@"-¥%.2f",[infoModel.goldNum floatValue]];
                }
                if (indexPath.row==oneSectionNum-1) {
                    
                    cell=[arrCell objectAtIndex:4];
                    
                    double needNum=[infoModel.price doubleValue]+[infoModel.goldNum floatValue];
                    cell.totalNum.text=[NSString stringWithFormat:@"总计¥%.2f",needNum];
                    cell.actualPrice.text=[NSString stringWithFormat:@"¥%.2f",[infoModel.price doubleValue]];
                }
                
            }
                break;
            case 1:
            {
                if (indexPath.row==0) {
                    
                    cell=[arrCell objectAtIndex:5];
                }
                if (indexPath.row==1) {
                    
                    cell=[arrCell objectAtIndex:6];
//                    
//                    NSString *newName=infoModel.addr[@"name"];
//                    NSString *newPhone=infoModel.addr[@"phone"];
//                    
                    
                    if ([_orderType intValue]==1) {
                        
                        cell.userNameAndPhone.text=@"无须配送";
                        cell.userAddress.text=@"";
                        
                    }else{
                        
                        cell.userNameAndPhone.text=[NSString stringWithFormat:@"%@   %@",infoModel.addr[@"name"],infoModel.addr[@"phone"]];
                        NSString *newStr=infoModel.addr[@"addrFull"];
                        cell.userAddress.text=(newStr.length>0)?[NSString stringWithFormat:@"%@",infoModel.addr[@"addrFull"]]:@"";
                        
                    }
                    
                    
                }
                
            }
                break;

            case 2:
            {
                if (indexPath.row==3) {
                    cell=[arrCell objectAtIndex:7];
                    cell.getNum.text=[NSString stringWithFormat:@"%@",infoModel.backGoldNum];
                    return cell;
                }
                
                cell=[arrCell objectAtIndex:5];
                cell.cell6Name.text=_cellLableArr[indexPath.row];
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.immediatelyGo.text=[NSString stringWithFormat:@"%@",infoModel.orderId];
                    }
                        break;
                    case 1:
                    {
                        cell.immediatelyGo.text=[NSString stringWithFormat:@"%@",[NSString showTimeFormat:infoModel.createDate Format:@"YYYY-MM-dd-HH:mm:ss"]];
                    }
                        break;

                    case 2:
                    {
                        if ([infoModel.payMethod intValue]==0) {
                            cell.immediatelyGo.text=@"线上支付";
                        }else{
                            
                            cell.immediatelyGo.text=@"到店支付";
                        }
                    }
                        break;

                        
                    default:
                        break;
                }
                return cell;
            }
                break;

                
            default:
                break;
        }
        
        return cell;
    }
    
    
    OrderDetaileTableViewCell *typeCell=[[OrderDetaileTableViewCell alloc]init];
    //0未付款，1:已付款 2:商家已确认 3:商家拒接 4:已发货 5:已收货 6:买家取消
    //做4类状态判断
    int  status=[infoModel.status intValue];
    switch (status) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    typeCell=orderType[2];
                    typeCell.payName.text=@"订单等待付款";
                    typeCell.payLabel.hidden=YES;
                }
                    break;
                case 1:
                {
                    typeCell=orderType[3];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    typeCell=orderType[2];
                    typeCell.payName.text=@"订单已支付成功";
                    typeCell.payLabel.hidden=YES;
                }
                    break;
                case 1:
                {
                    typeCell=orderType[3];
                }
                    
                default:
                    break;
            }
        }
            break;

        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    typeCell=orderType[1];
                    typeCell.shopComplete.text=@"商家已确认";
                    typeCell.storeName.text=@"商家已确认，配货进度请咨询商家客服。";
                }
                    break;
                case 1:
                {
                    typeCell=orderType[2];
                }
                    break;
                case 2:
                {
                    typeCell=orderType[3];
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;

        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    typeCell=orderType[4];
                    typeCell.endOrder.text=@"商家已取消订单";
                }
                    break;
                case 1:
                {
                    typeCell=orderType[3];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;

        case 4:
        {
            switch (indexPath.row) {
                case 0:
                {
                    typeCell=orderType[1];
                    typeCell.shopComplete.text=@"订单正在配送";
                }
                    break;
                case 1:
                {
                    typeCell=orderType[2];
                }
                    break;
                case 2:
                {
                    typeCell=orderType[3];
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;

        case 5:
        {
            switch (indexPath.row) {
                case 0:
                {
                    typeCell=orderType[0];
//                    typeCell.shopComplete.text=@"商家已确认";
                }
                    break;
                case 1:
                {
                    typeCell=orderType[1];
                }
                    break;
                case 2:
                {
                    typeCell=orderType[1];
                    typeCell.shopComplete.text=@"商家已确认";
                }
                    break;
                case 3:
                {
                    typeCell=orderType[2];
                }
                    break;
                case 4:
                {
                    typeCell=orderType[3];
//                    typeCell.shopComplete.text=@"商家已确认";
                }
                default:
                    break;
            }

        }
            break;
        case 6:
        {
            switch (indexPath.row) {
                case 0:
                {
                    typeCell=orderType[4];
                    typeCell.endOrder.text=@"用户已取消订单";
                }
                    break;
                case 1:
                {
                    typeCell=orderType[3];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;


            
        default:
            break;
    }
    
    
    return typeCell;
}


-(void)storeInfoBtnClick
{
//    if (infoModel.shopId.length==0) {
////        CategoryViewController * storeVC=[[CategoryViewController alloc]init];
//////        storeVC.hidesBottomBarWhenPushed=YES;
////        [self.navigationController pushViewController:storeVC animated:YES];
//    }
//    else
//    {
//        StoreInfoViewController *storeInfo=[[StoreInfoViewController alloc]init];
//        storeInfo.shopID=infoModel.shopId;
//        [self.navigationController pushViewController:storeInfo animated:YES];
//
//    }
    
    if ([_orderType intValue]==0) {
//        StoreInfoViewController *storeInfo=[[StoreInfoViewController alloc]init];
//        storeInfo.shopID=infoModel.shopId;
//        [self.navigationController pushViewController:storeInfo animated:YES];
    }
    else if ([_orderType intValue]==1)
    {
        SJXQViewController * sjxqVC=[[SJXQViewController alloc]init];
        sjxqVC.shopID=infoModel.shopId;
        [self.navigationController pushViewController:sjxqVC animated:YES];
    }
    else
    {
        
    }
    
}


#pragma mark - Jump
-(void)jump
{
    NSDictionary * param=@{@"orderId":_orderID,@"status":@"4"};
    [RequstEngine requestHttp:@"1019" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1019---%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"]intValue]==00000) {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"确认发货成功" buttonTitle:nil];
             [self requsteMyOrder];
        }
    }];
}

-(void)fuck:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            DMLog(@"确认接单");
        {
            NSDictionary * param=@{@"orderId":_orderID,@"status":@"2"};
            [RequstEngine requestHttp:@"1019" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1019---%@",dic);
                DMLog(@"error---%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"]intValue]==00000) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"确认接单成功" buttonTitle:nil];
                    [self requsteMyOrder];
                    
                }
            }];
        }
            break;
        case 1:
            DMLog(@"拒绝接单");
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否拒绝订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    DMLog(@"%f",scrollView.contentOffset.x);

    if (scrollView.tag!=1) return;
    
    int centerX=scrollView.contentOffset.x/KScreenWidth;
    if (centerX==currentX) return;
    
    currentX=centerX;
    if (centerX==0) {
        
        UIButton *newBtn=(UIButton *)[self.view viewWithTag:1];
        [newBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        [_selectedBtn setTitleColor:[UIColor grayColor] forState:0];
        _selectedBtn=newBtn;
        DMLog(@"%d",centerX);
        [UIView animateWithDuration:0.2 animations:^{
            
            _chooseLabel.center=CGPointMake(newBtn.center.x, _chooseLabel.center.y);
        }];
    }
    if (centerX==1) {
        
        UIButton *newBtn=(UIButton *)[self.view viewWithTag:2];
        [_selectedBtn setTitleColor:[UIColor grayColor] forState:0];
        [newBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        _selectedBtn=newBtn;
        //[self chooseOrderTypeButton:newBtn];
        DMLog(@"%d",centerX);
        [UIView animateWithDuration:0.2 animations:^{
            
            _chooseLabel.center=CGPointMake(newBtn.center.x, _chooseLabel.center.y);
        }];

    }

}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
        {
            NSDictionary * param=@{@"orderId":_orderID,@"status":@"3"};
            [RequstEngine requestHttp:@"1019" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1019---%@",dic);
                DMLog(@"error---%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"]intValue]==00000) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"拒绝接单成功" buttonTitle:nil];
                     _type=1;
                    [self requsteMyOrder];
                   
                }
            }];

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




- (IBAction)chooseOrderTypeButton:(id)sender {
    
    UIButton *newBtn=(UIButton *)sender;
    
    if (_selectedBtn!=newBtn) {
        
        [newBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        [_selectedBtn setTitleColor:[UIColor grayColor] forState:0];
        _selectedBtn=newBtn;
        
    }
    
    [_tabelScrollView setContentOffset:CGPointMake(KScreenWidth*(newBtn.tag-1), 0) animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _chooseLabel.center=CGPointMake(newBtn.center.x, _chooseLabel.center.y);
    }];
    
    switch (newBtn.tag) {
        case 1:
        {
            DMLog(@"订单状态");
            
        }
            break;
        case 2:
        {
            [_detailTableView reloadData];
            DMLog(@"订单详情");
        }
            break;
        default:
            break;
    }
}
@end
