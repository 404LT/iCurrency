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

+ (id)sharedInstance;

//用于定位plist里面存储的 国家名称  国旗   货币单位 
- (UIImage *)imageForCountriesFlag:(NSString *)countryName;
- (NSString *)nameForCurrency:(NSString *)countryName;
- (NSString *)unitForCurrency:(NSString *)countryName;

@property (nonatomic,strong)NSDictionary *currencies;//用来存储汇率

@property (strong,nonatomic)NSMutableArray *displayArray;//用来存储前台展示出来的国家，所有都应该用这个数组
@property (strong,nonatomic)NSMutableArray *namesArray;//全部国家名字

@property (strong,nonatomic,readonly)NSMutableArray *currencyUnit;//货币单位
@property (strong,nonatomic,readonly)NSMutableArray *flagImage;//国旗

- (void)initLocalNameSortList;
@end
