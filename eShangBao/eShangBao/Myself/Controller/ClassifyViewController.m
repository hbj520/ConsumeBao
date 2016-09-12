
//
//  ClassifyViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/22.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ClassifyViewController.h"
#import "ConsumerModel.h"
@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSArray * _dataArr;
    NSMutableArray * _nearArr;//经营分类数组
    NSMutableArray * _goodsArr;//商品分类数组
    NSMutableArray * _cateIdArr;//商品分类编码数组
}

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    _nearArr=[NSMutableArray arrayWithCapacity:0];
    _goodsArr=[NSMutableArray arrayWithCapacity:0];
    _cateIdArr=[NSMutableArray arrayWithCapacity:0];
    if (_classify==0) {
        self.title=@"经营分类";
        //    NSDictionary *param=@{@"shopId":USERID};
        [RequstEngine requestHttp:@"1008" paramDic:nil blockObject:^(NSDictionary *dic) {
            DMLog(@"1008--%@",dic);
            DMLog(@"error--%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"] intValue]==00000) {
                for (NSDictionary * myDic in dic[@"categoryList"]) {
                    ClassifyModel * model=[[ClassifyModel alloc]init];
                    [model setValuesForKeysWithDictionary:myDic];
                    [_nearArr addObject:model];
                    [_tableView reloadData];
                }
            }
        }];
    }
    else
    {
        self.title=@"商品分类";
        NSDictionary * param=@{@"shopId":USERID};
        [RequstEngine requestHttp:@"1009" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1009--%@",dic);
            DMLog(@"error--%@",dic[@"errorMsg"]);
            for (NSDictionary * newDic in dic[@"categoryList"]) {
                [_goodsArr addObject:newDic[@"cateName"]];
                [_cateIdArr addObject:newDic[@"cateId"]];
                [_tableView reloadData];
            }
        }];

    }
    
    self.view.backgroundColor=BGMAINCOLOR;
    _dataArr=@[@"美食",@"超市",@"生鲜",@"其他经营品类"];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=H(44);
    _tableView.separatorStyle=0;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_classify==0) {
         return _nearArr.count;
    }
    else
    {
        return _goodsArr.count;
    }
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_classify==0) {
        ClassifyModel * model=_nearArr[indexPath.row];
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle=0;
        cell.textLabel.text=model.cateName;
        cell.detailTextLabel.text=model.cateId;
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.textLabel.textColor=RGBACOLOR(80, 80, 80, 1);
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [cell.contentView addSubview:lineLabel];
        return cell;

    }
    else
    {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle=0;
        cell.textLabel.text=_goodsArr[indexPath.row];
        cell.detailTextLabel.text=_cateIdArr[indexPath.row];
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.textLabel.textColor=RGBACOLOR(80, 80, 80, 1);
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [cell.contentView addSubview:lineLabel];
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic=@{@"classify":cell.textLabel.text,@"cateId":cell.detailTextLabel.text};
    _block(dic);
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
