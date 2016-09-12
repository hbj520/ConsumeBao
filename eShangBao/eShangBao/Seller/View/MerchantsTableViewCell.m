//
//  MerchantsTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MerchantsTableViewCell.h"

@implementation MerchantsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)makeAPhoneCallBtn:(id)sender {
    
    DMLog(@"打电话%@",_storeCall.text);
    if (_storeCall.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"暂无商家电话" buttonTitle:nil];
    }
    else
    {
        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",_storeCall.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];

    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
