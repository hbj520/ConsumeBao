//
//  AddressViewController.h
//  eShangBao
//
//  Created by Dev on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumerModel.h"

@interface AddressViewController : UIViewController

@property(nonatomic,strong)AddressModel *addrModel;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
- (IBAction)addressButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *chooseVeiw;
@property (weak, nonatomic) IBOutlet UITextField *userName;//收姓名
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *floorTF;



@end
