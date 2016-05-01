//
//  CurrencyManager.m
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CurrencyManager.h"
@interface CurrencyManager()
@property (nonatomic,strong)NSDictionary *currencies;//用来存储汇率
@end

@implementation CurrencyManager

+ (instancetype)default
{
    static CurrencyManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CurrencyManager alloc] init];
    });
    return _manager;
}

- (id)init
{
    NSLog(@"从plist里面取出汇率相关的属性放在currencies里面");
    self = [super init];
    if (self) {
        NSString * plist = [[NSBundle mainBundle]pathForResource:@"currencies" ofType:@"plist"];
        self.currencies = [NSDictionary dictionaryWithContentsOfFile:plist];
        //从plist里面取出当前国家的 名称 国旗 货币单位放在currencies 里面
//        NSLog(@"currencies里面的内容的是~~~%@",self.currencies);
    }
    return self;
}

- (NSArray *)allCurrencyCodes
{
//    把plist里面所有的国家信息的键给存储在一个数组里面
    return [self.currencies allKeys];
}

- (UIImage *)imageForCountriesFlag:(NSString *)countryName
{
//    NSLog(@"设置界面显示的国家国旗");
    UIImage *flag;
    NSDictionary *flagInfo = [self.currencies objectForKey:countryName];
    //就是那些三位数简写国家名称的countryName
    NSString *flagName = [flagInfo objectForKey:@"flag"];
    if (flagName) {
        flag = [UIImage imageNamed:flagName];
    }
    
    return flag;
}

- (NSString *)nameForCurrency:(NSString *)countryName
{
//    NSLog(@"设置界面显示的货币名称");
    NSDictionary *nameInfo = [self.currencies objectForKey:countryName];
    return [nameInfo objectForKey:@"name"];
}

- (NSString *)unitForCurrency:(NSString *)countryName
{
//    NSLog(@"设置界面显示的货币单位");
    NSDictionary *unitInfo = [self.currencies objectForKey:countryName];
    return [unitInfo objectForKey:@"unit"];
}




@end
