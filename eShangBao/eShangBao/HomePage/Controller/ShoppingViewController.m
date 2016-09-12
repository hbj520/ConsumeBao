//
//  ShoppingViewController.m
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ShoppingViewController.h"
#import "HomeModel.h"
#import "ShoppingTableViewCell.h"
#import "SubmitViewController.h"
@interface ShoppingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray * _nearArr;
    UITableView * _tableView;
    int  _count;
    float  _price;
    float  _totlePrice;
    float  chooseTotalMoney;
    UILabel  *  _promptLabel;
    UIImageView  *  _headImg;
    UIView   *  _noOrderView;
    ShoppingModel * _model;
}

@property(nonatomic,strong)NSMutableArray          *chooseListArr;//选择的商品的数组
@property(nonatomic,strong)NSMutableDictionary     *chooseGoodsListDic;//选择的商品字典
@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"购物车";
    [self backButton];
    self.view.backgroundColor=BGMAINCOLOR;
    _nearArr=[NSMutableArray arrayWithCapacity:0];
    _chooseListArr=[NSMutableArray arrayWithCapacity:0];
    _chooseGoodsListDic=[NSMutableDictionary dictionaryWithCapacity:0];
    _deliveryFeeArr=[NSMutableArray arrayWithCapacity:0];
    _startPriceArr=[NSMutableArray arrayWithCapacity:0];
    [self mercharList];
    [self loadUI];
    // Do any additional setup after loading the view.
}

-(void)mercharList
{
    _totlePrice=0;
    [RequstEngine requestHttp:@"1072" paramDic:nil blockObject:^(NSDictionary *dic) {
        DMLog(@"1072---%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        if (_nearArr.count>0) {
            [_nearArr removeAllObjects];
        }
        if ([dic[@"errorCode"] intValue]==0) {
            for (NSDictionary * newDic in dic[@"recordList"]) {
                ShoppingModel * model=[[ShoppingModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_nearArr addObject:model];
                _price=[newDic[@"price"] floatValue]*[newDic[@"num"] intValue];
                _totlePrice+=_price;
            }
            if (_nearArr.count==0) {
                _noOrderView.hidden=NO;
                _tableView.hidden=YES;
            }
            else
            {
//                if (!_tableView) {
//                    [self loadUI];
//                }
                _noOrderView.hidden=YES;
                _tableView.hidden=NO;
            }
            _totleLabel.text=[NSString stringWithFormat:@"总计：￥%.2f",_totlePrice];
            [_tableView reloadData];
        }
    }];
    
    
    [RequstEngine requestHttp:@"1058" paramDic:nil blockObject:^(NSDictionary *dict) {
        DMLog(@"1058----%@",dict);
        DMLog(@"error---%@",dict[@"errorMsg"]);
        if ([dict[@"errorCode"] intValue]==0) {
            for (NSDictionary * newDic in dict[@"dataList"]) {
                
                [_deliveryFeeArr addObject:newDic[@"name"]];
                [_startPriceArr addObject:newDic[@"content"]];
                
                for (int i=0; i<_deliveryFeeArr.count; i++) {
                    if ([_deliveryFeeArr[i] isEqualToString:@"ZY_SEND_FEE"]) {
                        _deliveryFee=_startPriceArr[i];
                    }
                    if ([_deliveryFeeArr[i] isEqualToString:@"ZY_START_FEE"]) {
                        _startPrice=_startPriceArr[i];
                    }
                }
            }
        }
        DMLog(@"----%@,%@,%@",_deliveryFeeArr,_startPriceArr,_deliveryFee);
       
    }];

}

-(void)loadUI
{
    if (!_noOrderView) {
        
        _noOrderView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2.-87, KScreenHeight/2.-55, 174, 110)];
        [self.view addSubview:_noOrderView];
        
        UIImageView *myImageView=[[UIImageView alloc]initWithFrame:CGRectMake(87, 0, 72, 72)];
        myImageView.center=CGPointMake(174/2., 0);
        myImageView.image=[UIImage imageNamed:@"无订单"];
        [_noOrderView addSubview:myImageView];
        
        UILabel *noOrderlable=[[UILabel alloc]initWithFrame:CGRectMake(-(KScreenWidth/2.-87),CGRectGetMaxY(myImageView.frame)+10,WIDTH , 21)];
        noOrderlable.text=@"购物车中还没有商品，赶紧选购吧！";
        noOrderlable.textColor=[UIColor grayColor];
        noOrderlable.font=[UIFont systemFontOfSize:14];
        noOrderlable.textAlignment=NSTextAlignmentCenter;
        [_noOrderView addSubview:noOrderlable];
    }
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-H(50)-64) style:0];
    _tableView.backgroundColor=BGMAINCOLOR;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    [self.view addSubview:_tableView];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-H(50), WIDTH, H(50))];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    _totleLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, H(10), W(240), H(30))];
    _totleLabel.textColor=RGBACOLOR(255, 97, 0, 1);
    _totleLabel.font=[UIFont boldSystemFontOfSize:14];
    [coverView addSubview:_totleLabel];
    
    _accountBtn=[UIButton buttonWithType:0];
    _accountBtn.frame=CGRectMake(kRight(_totleLabel), H(10), W(50), H(30));
    _accountBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    _accountBtn.layer.masksToBounds=YES;
    _accountBtn.layer.cornerRadius=3;
    [_accountBtn setTitle:@"去结算" forState:0];
    [_accountBtn addTarget:self action:@selector(accountGoods) forControlEvents:1<<6];
    [_accountBtn setTitleColor:[UIColor whiteColor] forState:0];
    _accountBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_accountBtn];
    
    _clearAllBtn=[UIButton buttonWithType:0];
    _clearAllBtn.frame=CGRectMake(0, 0, 40, 40);
    [_clearAllBtn setTitle:@"清空" forState:0];
    [_clearAllBtn setTitleColor:[UIColor whiteColor] forState:0];
    _clearAllBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_clearAllBtn addTarget:self action:@selector(clearAllGoods) forControlEvents:1<<6];
    UIBarButtonItem * rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:_clearAllBtn];
    self.navigationItem.rightBarButtonItem=rightBtnItem;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingModel*model;
    if (_nearArr.count>0) {
        model=_nearArr[indexPath.row];
    }
//    SellerGoodsListModel *chooseModel=[_chooseGoodsListDic objectForKey:model.goodsId];
    ShoppingTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[ShoppingTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=0;
//    cell.textLabel.text=@"222222222";
    [cell.headImg setImageWithURLString:model.imgUrl placeholderImage:@"默认商家"];
    cell.nameLabel.text=model.goodsName;
    cell.countLabel.text=[NSString stringWithFormat:@"%@",model.num];
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    
    [cell.addBtn addTarget:self action:@selector(addGoods:) forControlEvents:1<<6];
    cell.addBtn.tag=indexPath.row;
    [cell.reduceBtn addTarget:self action:@selector(reduceGoods:) forControlEvents:1<<6];
    cell.reduceBtn.tag=indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteGoods:) forControlEvents:1<<6];
    cell.deleteBtn.tag=indexPath.row;
    
    [self getGoodsinfoData:model];
    return cell;
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
            if (alertView.tag==20) {
                NSDictionary* param=@{@"shopcartId":_shopcartId,@"isAll":@"0"};
                [RequstEngine requestHttp:@"1071" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1071----%@",dic);
                    DMLog(@"error----%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==0) {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"删除商品成功" buttonTitle:nil];
                        NSString *chooseID=_model.goodsId;
                        [_chooseGoodsListDic removeObjectForKey:chooseID];
                        [self mercharList];
                    }
                }];
            }
            else
            {
                NSDictionary* param=@{@"shopcartId":@"",@"isAll":@"1"};
                [RequstEngine requestHttp:@"1071" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1071----%@",dic);
                    DMLog(@"error----%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==0) {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"清空购物车成功" buttonTitle:nil];
                        [self mercharList];
                    }
                }];
            }
            break;
        default:
            break;
    }
}
-(void)addGoods:(UIButton *)sender
{
    ShoppingModel * model=_nearArr[sender.tag];
    _count=[model.num intValue];
    _count++;
    NSDictionary* param=@{@"shopcartId":model.shopcartId,@"num":[NSString stringWithFormat:@"%d",_count]};
    [RequstEngine requestHttp:@"1070" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1070----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            [self mercharList];
        }
    }];
}

-(void)reduceGoods:(UIButton *)sender
{
    ShoppingModel * model=_nearArr[sender.tag];
    _count=[model.num intValue];
    _count--;
    if (_count==0) {
        
    }
    else
    {
        NSDictionary* param=@{@"shopcartId":model.shopcartId,@"num":[NSString stringWithFormat:@"%d",_count]};
        [RequstEngine requestHttp:@"1070" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1070----%@",dic);
            DMLog(@"error----%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"] intValue]==0) {
                [self mercharList];
            }
        }];
    }
   

}

-(void)deleteGoods:(UIButton *)sender
{
    ShoppingModel * model=_nearArr[sender.tag];
    _shopcartId=model.shopcartId;
    _model=model;
    UIAlertView * deleteGoodsAlertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确认删除该商品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    deleteGoodsAlertView.tag=20;
    deleteGoodsAlertView.delegate=self;
    [deleteGoodsAlertView show];
    
}

-(void)accountGoods
{
    [_tableView reloadData];
    
    if (_nearArr.count==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"购物车中还没有商品，赶紧选购吧！" buttonTitle:nil];
    }
    else if ([_startPrice floatValue]>chooseTotalMoney)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"商品价格低于起送价" buttonTitle:nil];
    }
    else
    {
        SubmitViewController *submitVC=[[SubmitViewController alloc]init];
        submitVC.chooseListDic=_chooseGoodsListDic;
        submitVC.chooseListArr=_chooseListArr;
        submitVC.whichPage=1;
        submitVC.deliveryFee=_deliveryFee;
        submitVC.chooseTotalMoney=chooseTotalMoney;
        [self.navigationController pushViewController:submitVC animated:YES];
    }
   
}

-(void)getGoodsinfoData:(ShoppingModel *)shoppingModel
{
    DMLog(@"_____%@",shoppingModel);
    [_chooseListArr removeAllObjects];
//    [_chooseGoodsListDic removeAllObjects];
    NSString *chooseID=shoppingModel.goodsId;
    
    if ([shoppingModel.num intValue]==0) {
        
        [_chooseGoodsListDic removeObjectForKey:chooseID];
        
    }else{
        
        [_chooseGoodsListDic setObject:shoppingModel forKey:chooseID];
    }
    for (NSString *goodsId in [_chooseGoodsListDic allKeys]) {
        
        [_chooseListArr addObject:goodsId];
        
    }
    DMLog(@"arr————%@",_chooseListArr);
    double sumTotal=0;
    int    changeChooseNum=0;
    for (ShoppingModel *goodsModel in [_chooseGoodsListDic allValues]) {
        
        double goodsPrice=[goodsModel.price doubleValue]*[goodsModel.num intValue];
        changeChooseNum=changeChooseNum+[goodsModel.num intValue];
        sumTotal=goodsPrice+sumTotal;
        
    }
    chooseTotalMoney=sumTotal;
   

}

-(void)clearAllGoods
{
    if (_nearArr.count==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"购物车中还没有商品，赶紧选购吧！" buttonTitle:nil];
    }
    else
    {
        UIAlertView * clearAllAlertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确认清空购物车" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        clearAllAlertView.delegate=self;
        clearAllAlertView.tag=21;
        [clearAllAlertView show];
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
