//
//  ExchangeRate.m
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//
#import "YahooFinanceClient.h"
#import "ExchangeRate.h"

NSString *const kKeyBaseCurrencyName = @"baseCurrencyName";
NSString *const kKeyRates = @"rates";
NSString *const kKeyLastUpdated = @"lastUpdated";



@interface ExchangeRate()
@property(nonatomic,weak)YahooFinanceClient *yahooClient;
@end
@implementation ExchangeRate
//主力方法
- (double)convertRate:(NSString *)baseCurrencyName
                   to:(NSString *)targetCurrencyName
                 with:(float)number
{
    NSLog(@"换算中~~~~~~：");

    //    应该在这里使用解档的汇率
    YahooFinanceClient *financeClient = [[YahooFinanceClient alloc]init];

    NSDictionary *latestRateDictionary = [financeClient reserveLatestDic];
    


    NSLog(@"初始化汇率的dic");
    
    if([baseCurrencyName  isEqualToString:@"USD"])
    {
        float targetRateValue = [[latestRateDictionary valueForKey:[NSString stringWithFormat:@"USD/%@",targetCurrencyName]]floatValue];
        float convertResult = targetRateValue * number;
        return convertResult;
    }
    else
    {
        float baseTargetRate = [[latestRateDictionary valueForKey:[NSString stringWithFormat:@"USD/%@",baseCurrencyName]]floatValue];
        float targetRateValue = [[latestRateDictionary valueForKey:[NSString stringWithFormat:@"USD/%@",targetCurrencyName]]floatValue];
        float convertResult = targetRateValue/baseTargetRate*number;
        return convertResult;
    }
}

#pragma mark - NSCoding

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super init];
//    if (self) {
//        self.baseCurrencyName = [aDecoder decodeObjectForKey:kKeyBaseCurrencyName];
//        self.rates = [aDecoder decodeObjectForKey:kKeyRates];
//        self.lastUpdated = [aDecoder decodeObjectForKey:kKeyLastUpdated];
//    }
//    NSLog(@"解档基础汇率id 汇率 最后更新时间");
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.baseCurrencyName forKey:kKeyBaseCurrencyName];
//    [aCoder encodeObject:self.rates forKey:kKeyRates];
//    [aCoder encodeObject:self.lastUpdated forKey:kKeyLastUpdated];
//    NSLog(@"用来归档 基础汇率国家代码 汇率 更新时间");
//}

#pragma mark - 汇率的一些操作
//- (BOOL)save
//{
//    NSLog(@"存起来");
//    BOOL result = [NSKeyedArchiver archiveRootObject:self toFile:[ExchangeRate filePath]];
//    return result;
//}
//
//+(NSString *)filePath
//{
//    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//    NSString *filePath = [docsPath stringByAppendingString:@"rates"];
//    NSLog(@"filePath is :%@",filePath);
//    return filePath;
//}
//
//- (BOOL)isStale
//{
//    NSLog(@"判断汇率是不是新的");
//    BOOL result = [NSKeyedArchiver archiveRootObject:self toFile:[ExchangeRate filePath]];
//    return result;
//}
//
//+ (ExchangeRate *)load
//{
//    ExchangeRate *rate = [NSKeyedUnarchiver unarchiveObjectWithFile:[ExchangeRate filePath]];
//    return rate;
//}


@end
