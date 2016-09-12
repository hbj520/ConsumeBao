//
//  ChooseProvinceViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/23.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
#import "HomeModel.h"

typedef void(^returnCityModel)(CityModel *provinceModel);

@interface ChooseProvinceViewController : UIViewController
{
    int _buttonClickCount[3] ;
}

@property(nonatomic,copy) returnCityModel returnCity;

-(void)returnCity:(returnCityModel)block;


@end
