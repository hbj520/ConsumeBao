//
//  SetViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SetViewController.h"
#import "SetPsdViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@interface SetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    UITableView * _tableView;
    float  _cache;//缓存
}
@end

@implementation SetViewController

- (void)viewWillAppear:(BOOL)animated
{
    //self.fd_prefersNavigationBarHidden=NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (![NSString isLogin]) {
        _leaveBtn.hidden=YES;
        _uploadBtn.hidden=NO;
    }
    else
    {
        _leaveBtn.hidden=NO;
        _uploadBtn.hidden=YES;
    }
   
}

-(void)requsetShareContent
{
    
    NSDictionary *param=@{@"requestType":@"0"};
    [RequstEngine requestHttp:@"1058" paramDic:param blockObject:^(NSDictionary *dic) {
        
         DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            for (NSDictionary *newDic in dic[@"dataList"]) {
                
                if ([newDic[@"name"] isEqualToString:@"APP_SHARE"]) {
                    NSData *jsonData = [newDic[@"content"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSError *err;
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                         
                                                                        options:NSJSONReadingMutableContainers
                                         
                                                                          error:&err];
//                    NSDictionary *contentDic=newDic[@"content"];
                    _shareDic=dic;
 
                }
            }
//            DMLog
            [_tableView reloadData];
            
            
        }
        
       
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"设置";
    self.view.backgroundColor=BGMAINCOLOR;

    _shareDic=[NSDictionary dictionary];
    
    [self requsetShareContent];
    //self.fd_prefersNavigationBarHidden=NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, H(44)*3+H(10)*3) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.scrollEnabled=NO;
//    _tableView.rowHeight=H(44);
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:_tableView];
    

//    if (![NSString isLogin]) {
    
        _uploadBtn=[UIButton buttonWithType:0];
        _uploadBtn.layer.cornerRadius=3;
        _uploadBtn.layer.masksToBounds=YES;
        _uploadBtn.frame=CGRectMake(W(20), kDown(_tableView)+H(180), WIDTH-W(20)*2, 40);
        _uploadBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
        [_uploadBtn setTitle:@"请先登录" forState:0];
        [_uploadBtn addTarget:self action:@selector(loginFirst) forControlEvents:1<<6];
        [_uploadBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self.view addSubview:_uploadBtn];
        
//        _uploadBtn.hidden=YES;
        _leaveBtn=[UIButton buttonWithType:0];
        _leaveBtn.layer.cornerRadius=3;
        _leaveBtn.layer.masksToBounds=YES;
        _leaveBtn.frame=CGRectMake(W(20), kDown(_tableView)+H(180), WIDTH-W(20)*2, 40);
        _leaveBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
        [_leaveBtn setTitle:@"退出登录" forState:0];
        [_leaveBtn addTarget:self action:@selector(uploadImg) forControlEvents:1<<6];
        [_leaveBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self.view addSubview:_leaveBtn];
        
//    }

   

    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        }
        
        cell.selectionStyle=0;
        cell.accessoryType=1;
        cell.textLabel.text=@"分享我们";
        cell.textLabel.textColor=MAINCHARACTERCOLOR;
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        return cell;
    }
    else if(indexPath.section==1)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle=0;
        cell.textLabel.text=@"清空缓存";
        _cache=[self filePath];
        cell.textLabel.textColor=MAINCHARACTERCOLOR;
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.1f M",_cache];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
        return cell;
    }
    else
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        }
        
        cell.selectionStyle=0;
        cell.accessoryType=1;
        cell.textLabel.textColor=MAINCHARACTERCOLOR;
        cell.textLabel.text=@"设置通宝币支付密码";
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        return cell;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return H(10);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==0) {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否清空缓存图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if(indexPath.section==0&&indexPath.row==0)
    {
        DMLog(@"999");
        NSArray* imageArray = @[[UIImage imageNamed:@"shareIcon"]];
        if (imageArray) {
            
            
            //调用分享的方法
            
            
            
            
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:_shareDic[@"content"]
                                             images:imageArray
                                                url:[NSURL URLWithString:_shareDic[@"link"]]
                                              title:@"天俊消费宝"
                                               type:SSDKContentTypeAuto];
            
            
            SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                
                switch (state) {
                    case SSDKResponseStateSuccess:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                        message:[NSString stringWithFormat:@"%@",error]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil, nil];
                        [alert show];
                        break;
                    }
                    default:
                        break;
                }

                
            }];
            
            [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];

            
            
//            //2、分享（可以弹出我们的分享菜单和编辑界面）
//            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                     items:nil
//                               shareParams:shareParams
//                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                           
//                           switch (state) {
//                               case SSDKResponseStateSuccess:
//                               {
//                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                       message:nil
//                                                                                      delegate:nil
//                                                                             cancelButtonTitle:@"确定"
//                                                                             otherButtonTitles:nil];
//                                   [alertView show];
//                                   break;
//                               }
//                               case SSDKResponseStateFail:
//                               {
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                                   message:[NSString stringWithFormat:@"%@",error]
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"OK"
//                                                                         otherButtonTitles:nil, nil];
//                                   [alert show];
//                                   break;
//                               }
//                               default:
//                                   break;
//                           }
//                       }
//             ];
        }
    }
    else
    {
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            SetPsdViewController * setPsdVC=[[SetPsdViewController alloc]init];
            [self.navigationController pushViewController:setPsdVC animated:YES];

        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H(44);
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            
        {
//            [[SDImageCache sharedImageCache]clearDisk];
//            [_tableView reloadData];
            [self clearFile];
        }
            break;
        default:
            break;
    }
   
}

// 显示缓存大小

- ( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];

    return [ self folderSizeAtPath :cachPath];

}

//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
  
    NSFileManager * manager = [ NSFileManager defaultManager ];

    if ([manager fileExistsAtPath :filePath]){
      
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
      
    }
  
    return 0 ;

}

//2: 遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
 
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
  
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
  
    NSString * fileName;
 
    long long folderSize = 0 ;
   
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
  
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
  
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
 
    }
    return folderSize/( 1024.0 * 1024.0 );
}

// 清理缓存

- (void)clearFile
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}
-(void)clearCachSuccess
{
    NSLog ( @" 清理成功 " );
    
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:1];//刷新
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];}


-(void)uploadImg
{
    DMLog(@"退出登录");
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userID"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userType"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"levelName"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"parterLevel"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"partnerAgencyPayStatus"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"goldNum"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"inviteCode"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selfPhone"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginName"];
    
//    [[NSUserDefaults standardUserDefaults]remo]
    
    if ([USERID isEqualToString:@""] ) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"您已退出登录" buttonTitle:nil];
        [self loginUser];
    }
}

-(void)loginFirst
{
    [self loginUser];
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
