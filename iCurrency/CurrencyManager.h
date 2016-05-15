//
//  CurrencyManager.h
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CurrencyManager : NSObject//<NSCoding>

- (NSArray *)allCurrencyCodes;

+ (id)sharedInstance;

//用于定位plist里面存储的 国家名称  国旗   货币单位 
- (UIImage *)imageForCountriesFlag:(NSString *)countryName;
- (NSString *)nameForCurrency:(NSString *)countryName;
- (NSString *)unitForCurrency:(NSString *)countryName;

@property (nonatomic,strong)NSDictionary *currencies;//用来存储汇率


@property (strong,nonatomic)NSMutableArray *namesArray;//全部国家名字
@property (strong,nonatomic)NSMutableArray *currencyUnit;//货币单位
@property (strong,nonatomic)NSMutableArray *flagImage;//国旗

@property (nonatomic,strong)NSMutableArray *allCurrenciesInfo;//存储汇率信息的字典

- (void)initLocalNameSortList;


@property (strong,nonatomic)NSMutableArray *defaultsCountries;//用来存储前台默认展示出来的国家//自选操作
- (void)addDisplayCurrencyName:(NSString *)name;
- (void)removeDisplayCurrencyName:(NSString *)name;

// 文件处理
- (void)saveDisplay;
- (void)loadDisplay;



@end
