//
//  SubmitTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SubmitTableViewCell.h"

@implementation SubmitTableViewCell

- (void)awakeFromNib {
    
    _chooseCoinTF.returnKeyType=UIReturnKeyDone;
    _tongbaobiNum.keyboardType=UIKeyboardTypeDecimalPad;
    _chooseCoinTF.textAlignment=2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)payWaybuttonClick:(id)sender {
    
    UIButton *newButton=(UIButton *)sender;
    switch (newButton.tag) {
        case 1:
        {
            //在线
            _onlinePayImage.image=[UIImage imageNamed:@"3-(2)选择_03"];
            _offlinePayImage.image=[UIImage imageNamed:@"3-(2)选择_06"];
            [_delegate payMethod:@"0"];

        }
            break;
        case 2:
        {
            _offlinePayImage.image=[UIImage imageNamed:@"3-(2)选择_03"];
            _onlinePayImage.image=[UIImage imageNamed:@"3-(2)选择_06"];
            [_delegate payMethod:@"1"];
            
            //线下
        }
            break;
            
        default:
            break;
    }
    
}
- (IBAction)vouchersChooseButton:(id)sender {
    
    if (_chooseVouchersPay) {
        _vouchersChooseImage.image=[UIImage imageNamed:@"3-(2)选择_03"];
        _chooseVouchersPay=NO;
    }else{
         _vouchersChooseImage.image=[UIImage imageNamed:@"3-(2)选择_06"];
        _chooseVouchersPay=YES;
    }
}


- (IBAction)addAddressButton:(id)sender {
    
    
    
    
    
}


@end
