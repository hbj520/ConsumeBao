
//
//  ChooseProvinceViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/23.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ChooseProvinceViewController.h"

@interface ChooseProvinceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * _cityArr;
}

@end

@implementation ChooseProvinceViewController

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    _cityArr=[NSMutableArray arrayWithCapacity:0];
    [RequstEngine requestHttp:@"1050" paramDic:nil blockObject:^(NSDictionary *dic) {
        DMLog(@"1050---%@",dic);
        if ([dic[@"errorCode"] intValue]==00000) {
            
            for (NSDictionary * newDic in dic[@"lstProvince"]) {
                ProvinceModel * model=[[ProvinceModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_cityArr addObject:model];
//                
//                for (NSDictionary * dict in newDic[@"lstCity"]) {
//                    
//                    [_dataArray addObject:dict[@"cityName"]];
//                }
            }
            [_tableView reloadData];
            [self loadUI];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.view.backgroundColor=BGMAINCOLOR;
    self.title=@"所在地区";
//    _cityArr=[NSMutableArray arrayWithObjects:@"安徽省",@"湖北省",@"湖南省",@"四川省",@"天津市",@"福建省",@"江苏省",@"上海市",@"云南省",@"河北省",@"河南省",@"浙江省",@"北京市",@"山东省",@"陕西省", nil];
   
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(5)+64, W(200), H(20))];
    titleLabel.textColor=GRAYCOLOR;
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.text=@"请选择省份";
    [self.view addSubview:titleLabel];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kDown(titleLabel)+H(10), WIDTH, HEIGHT-H(10)-H(5)-H(20)-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=H(44);
    _tableView.sectionHeaderHeight=H(44);
    _tableView.separatorStyle=0;
    [self.view addSubview:_tableView];
    
    DMLog(@"*****%@",_cityArr);
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cityArr.count;
//    DMLog(@"---%ld",_cityArr.count);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = _buttonClickCount[section];
    
    if (count %2 == 0)
    {
        //闭合
        return 0 ;
    }else
    {
        CityModel * model=_cityArr[section];
        return model.lstCity.count;
//        DMLog(@"model.count---%ld",model.lstCity.count);
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProvinceModel * model=_cityArr[indexPath.section];
    NSArray *cityName=model.lstCity;
    NSDictionary *citydic=cityName[indexPath.row];
    CityModel *cityModel=[[CityModel alloc] init];
    [cityModel setValuesForKeysWithDictionary:citydic];
    DMLog(@"%@",cityModel.name);
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=0;
    cell.textLabel.text=[NSString stringWithFormat:@"    %@",cityModel.name];

    cell.textLabel.textColor=MAINCHARACTERCOLOR;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [cell.contentView addSubview:lineLabel];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProvinceModel * model=_cityArr[section];
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(44))];
    view.backgroundColor=[UIColor whiteColor];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(12), W(80), H(20))];
    label.font=[UIFont systemFontOfSize:14];
    label.text=model.name;
    label.textColor=MAINCHARACTERCOLOR;
    [view addSubview:label];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [view addSubview:lineLabel];
    
    UIButton*clickButton=[UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame=CGRectMake(0, 0, WIDTH, H(44));
    [clickButton addTarget:self action:@selector(expand:) forControlEvents:UIControlEventTouchUpInside];
    clickButton.tag=section+1;
    [view addSubview:clickButton];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ProvinceModel * model=_cityArr[indexPath.section];
//    NSArray *cityName=model.lstCity;
    
    ProvinceModel * model=_cityArr[indexPath.section];
    NSArray *cityName=model.lstCity;
    NSDictionary *citydic=cityName[indexPath.row];
    CityModel *cityModel=[[CityModel alloc] init];
    [cityModel setValuesForKeysWithDictionary:citydic];

//    CityModel *cityModel=cityName[indexPath.row];
    if (self.returnCity!=nil) {
        
        self.returnCity(cityModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
  
}
-(void)returnCity:(returnCityModel)block
{
    self.returnCity=block;
}

-(void)expand:(UIButton * )button
{
    _buttonClickCount[button.tag-1]++;
    NSIndexSet * set = [[NSIndexSet alloc]initWithIndex:button.tag-1];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
//    [_tableView reloadData];
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
