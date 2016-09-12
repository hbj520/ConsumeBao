//
//  XFZCViewController.m
//  eShangBao
//
//  Created by Dev on 16/6/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "XFZCViewController.h"
#import "HHRViewController.h"
#import "SYQMoneyTableViewCell.h"

@interface XFZCViewController ()

@end

@implementation XFZCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消费众筹";
    [self backButton];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createMyTableView];
    if (_projectModelArr.count==0) {
        
        _projectModelArr=[NSMutableArray arrayWithCapacity:0];
        [self merchantsList];
        
    }else{
        
        //[self createlisteView];
    }
    
    
    
    // Do any additional setup after loading the view.
}
-(void)createMyTableView
{
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _myTableView.dataSource=self;
    _myTableView.delegate=self;
    _myTableView.separatorStyle=0;
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    _myTableView.tableFooterView=footView;
    [self.view addSubview:_myTableView];
    
}


//-(void)createlisteView
//{
//    UIScrollView *bgScrollView=[[UIScrollView alloc]initWithFrame:self.view.frame];
//    bgScrollView.contentSize=CGSizeMake(0, 130*_projectModelArr.count+10);
//    [self.view addSubview:bgScrollView];
//    //NSArray *imageArr=@[@"cyhhr_banner",@"ys_banner",@"js_banner",@"zs_banner"];
//    
//    for (int i = 0; i<_projectModelArr.count; i++) {
//        
//        ProjectIntroductionModel *model=_projectModelArr[i];
//        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, W(130)*i, KScreenWidth, W(130))];
//        [bgScrollView addSubview:bgView];
//        
//        UIButton *detailsButton=[UIButton buttonWithType:0];
//        detailsButton.frame=CGRectMake(8, 10, KScreenWidth-16, W(130)-10);
//        detailsButton.tag=i;
//        [detailsButton addTarget:self action:@selector(detailsButtonClick:) forControlEvents:1<<6];
//        [bgView addSubview:detailsButton];
//        
//        UIImageView *imageView=[[UIImageView alloc]initWithFrame:detailsButton.frame];
//        [imageView setImageWithURLString:model.imgUrl placeholderImage:DEFAULTADVERTISING];
//        [bgView addSubview:imageView];
//        
//    }
//}


-(void)merchantsList
{
    
    
    NSDictionary *param=@{@"type":@"0",@"minLevel":@""};
    [RequstEngine requestHttp:@"1023" paramDic:param blockObject:^(NSDictionary *dic) {
        
        
        DMLog(@"dic=====%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            
            for (NSDictionary *newDic in dic[@"categoryList"]) {
                ProjectIntroductionModel *model=[[ProjectIntroductionModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_projectModelArr addObject:model];
            }
            
            [_myTableView reloadData];
        }
        
    }];
    
    
    
}

#pragma mark - tableViewDelegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projectModelArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 8+W(120);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectIntroductionModel *model=_projectModelArr[indexPath.row];
    static NSString *cellName=@"xfzcCell";
    SYQMoneyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];

    if (!cell) {
        
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SYQMoneyTableViewCell" owner:nil options:nil] objectAtIndex:1];

        
    }
    
    [cell.xfzcImage setImageWithURLString:model.imgUrl placeholderImage:DEFAULTADVERTISING];
    cell.selectionStyle=0;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectIntroductionModel *model=_projectModelArr[indexPath.row];
    HHRViewController *hhrVC=[[HHRViewController alloc]init];
    //hhrVC.VCType=(int)sender.tag;
    hhrVC.projectModel=model;
    [self.navigationController pushViewController:hhrVC animated:YES];
    //DMLog(@"选择第%ld",sender.tag);
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
