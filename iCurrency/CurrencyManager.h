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

+ (id)sharedInstance;//单例

//用于定位plist里面存储的 国家名称  国旗   货币单位

@property (nonatomic,strong)NSDictionary *currencies;//用来存储汇率


@property (strong,nonatomic)NSMutableArray *defaultsCountries;//用来存储前台默认展示出来的自选国家。
@property (strong,nonatomic)NSArray *namesArray;//全部国家名字
@property (strong,nonatomic)NSMutableArray *currencyUnit;//货币单位
@property (strong,nonatomic)NSMutableArray *flagImage;//国旗
@property (strong, nonatomic) NSString *name;
//- (void)initLocalNameSortList;//本类的初始化方法不应该暴露出共有接口？？


- (void)addDisplayCurrencyName:(NSString *)name;
- (void)removeDisplayCurrencyName:(NSString *)name;

// 文件处理
- (void)saveDisplay;
- (void)loadDisplay;



@end
