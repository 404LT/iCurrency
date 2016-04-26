//
//  CurrencyManager.h
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CurrencyManager : NSObject

- (NSArray *)allCurrencyCodes;

//用于定位plist里面存储的 国家名称  国旗   货币单位 
- (UIImage *)imageForCountriesFlag:(NSString *)countryName;
- (NSString *)nameForCurrency:(NSString *)countryName;
- (NSString *)unitForCurrency:(NSString *)countryName;

@end
