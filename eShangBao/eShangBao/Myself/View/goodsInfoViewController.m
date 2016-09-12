//
//  goodsInfoViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "goodsInfoViewController.h"
#import "goodInfoView.h"
#import "GoodsInfoTableViewCell.h"
#import "AddGoodsViewController.h"
#import "CollectModel.h"

@interface goodsInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    goodInfoView *headView;
    goodInfoView *goodsInfoHeadView;
    
    GoodsInfoModel *infoModel;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong)NSMutableArray       *goodsImageArr;//详情图片数组

@end

@implementation goodsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"商品详情";
    infoModel=[[GoodsInfoModel alloc]init];
    _goodsImageArr=[NSMutableArray arrayWithCapacity:0];
    
    
    [self requsetGoodsInfo];
    headView=[[[NSBundle mainBundle] loadNibNamed:@"goodInfoView" owner:nil options:nil] objectAtIndex:0];
    goodsInfoHeadView =[[[NSBundle mainBundle] loadNibNamed:@"goodInfoView" owner:nil options:nil] objectAtIndex:1];
    
}

-(void)requsetGoodsInfo
{
    NSDictionary *param=@{@"goodsId":_goodsID};
    [RequstEngine requestHttp:@"1039" paramDic:param blockObject:^(NSDictionary *dic) {
        
        
        DMLog(@"1039----%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            
            [infoModel setValuesForKeysWithDictionary:dic[@"data"]];
        }
        headView.goodsModel=infoModel;
        for (NSString *imageUrl in infoModel.imgList) {
            
            [_goodsImageArr addObject:imageUrl];
            
        }
        [_myTableView reloadData];
    }];
    
    
    
}



#pragma mark tableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return headView;
        
    }
    return goodsInfoHeadView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 322;
    }
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return _goodsImageArr.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
//#warning 此处需要计算文字的高度给出具体的显示高度 之前需要先判断有没有文字
        if (indexPath.row==0) {
            
            float stringH=[NSString calculatemySizeWithFont:14 Text:infoModel.details width:KScreenWidth-16];
            if (stringH==0 ) {
                return 0;
            }
            
            return 30+stringH;
            
            
        }
        return WIDTH*2/3;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSArray *cellArr=[[NSBundle mainBundle]loadNibNamed:@"GoodsInfoTableViewCell" owner:nil options:nil];
    GoodsInfoTableViewCell *cell;
    
    if (indexPath.section==1) {
//#warning 具体需不需要显示文字 待判断
        if (indexPath.row==0) {
            
            cell=[cellArr objectAtIndex:0];
            cell.goodsDescribe.text=infoModel.details;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }else{
            
            NSString *imageUrl=_goodsImageArr[indexPath.row-1];
            cell=[cellArr objectAtIndex:1];
            [cell.goodsInfoImage setImageWithURLString:imageUrl placeholderImage:DEFAULTIMAGE];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
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
