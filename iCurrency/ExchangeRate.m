//
//  ExchangeRate.m
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//
#import "YahooFinanceClient.h"
#import "ExchangeRate.h"
@interface ExchangeRate()
@property(nonatomic,weak)YahooFinanceClient *yahooClient;
@end
@implementation ExchangeRate
//主力方法
- (double)convertRate:(NSString *)baseCurrencyName
                   to:(NSString *)targetCurrencyName
                 with:(float)number
{
    NSLog(@"+++++++++开始换算");
    NSLog(@"换算中~~~~~~：");
    YahooFinanceClient *financeClient = [[YahooFinanceClient alloc]init];
//    NSDictionary *latestRateDictionary = [financeClient getParsedDictionaryFromResults];//这里发送一个获取静态dic的方法
    NSDictionary *latestRateDictionary = [financeClient reserveLatestDic];
    
//你这样的意思就是每次执行换算的时候都从雅虎那里重新申请获取全部汇率信息了。。。
//应该直接获取一个本地的静态存储汇率的dic，而不是每次需要使用都调用网络获取的方法去获取。。
    
    NSLog(@"初始化汇率的dic");
    
    
    if([baseCurrencyName  isEqualToString:@"USD"])
    {
        NSLog(@"判断是不是USD为基础汇率");
        float targetRateValue = [[latestRateDictionary valueForKey:[NSString stringWithFormat:@"USD/%@",targetCurrencyName]]floatValue];
        float convertResult = targetRateValue * number;
        NSLog(@"+++++++++++换算结束");
        return convertResult;
    }
    else
    {
        NSLog(@"USD不是基础汇率");
        float baseTargetRate = [[latestRateDictionary valueForKey:[NSString stringWithFormat:@"USD/%@",baseCurrencyName]]floatValue];
        float targetRateValue = [[latestRateDictionary valueForKey:[NSString stringWithFormat:@"USD/%@",targetCurrencyName]]floatValue];
        float convertResult = targetRateValue/baseTargetRate*number;
        NSLog(@"+++++++++换算结束");
        return convertResult;
    }
    
}
@end
