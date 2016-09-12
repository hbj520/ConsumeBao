//
//  MerchantsTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *businessTime;


@property (weak, nonatomic) IBOutlet UILabel *storeCall;

@property (weak, nonatomic) IBOutlet UILabel *storeAddress;

@end
