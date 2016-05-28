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



#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"NSCoding解档 ");
    self = [super init];
    if (self) {
        self.rates = [aDecoder decodeObjectForKey:kKeyRates];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.rates forKey:kKeyRates];
    NSLog(@"用来归档 ");
}
#pragma mark - 汇率的一些操作
+ (ExchangeRate *)load
{
    NSLog(@"load");
    //把存储在本地document当中的rates给加载出来
    ExchangeRate *rate = [NSKeyedUnarchiver unarchiveObjectWithFile:[ExchangeRate filePath]];
    return rate;
}
- (BOOL)save
{
    //NSLog(@"存起来");
    BOOL result = [NSKeyedArchiver archiveRootObject:self toFile:[ExchangeRate filePath]];
    return result;
}

+(NSString *)filePath
{
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [docsPath stringByAppendingString:@"rates.plist"];
  //  NSLog(@"filePath is %@",filePath);
    return filePath;
}
//
//- (BOOL)isStale
//{
//    NSLog(@"判断汇率是不是新的");
//    BOOL result = [NSKeyedArchiver archiveRootObject:self toFile:[ExchangeRate filePath]];
//    return result;
//}
//


#pragma mark - 转换方法
- (double)convertRate:(NSString *)baseCurrencyName
                   to:(NSString *)targetCurrencyName
                 with:(float)number
{
    NSLog(@"换算中~~~~~~ rates is ：%@",self.rates);
    if([baseCurrencyName  isEqualToString:@"USD"])
    {
        float targetRateValue = [[self.rates valueForKey:[NSString stringWithFormat:@"USD/%@",targetCurrencyName]]floatValue];
        float convertResult = targetRateValue * number;
        return convertResult;
    }
    else
    {
        float baseTargetRate = [[self.rates valueForKey:[NSString stringWithFormat:@"USD/%@",baseCurrencyName]]floatValue];
        float targetRateValue = [[self.rates valueForKey:[NSString stringWithFormat:@"USD/%@",targetCurrencyName]]floatValue];
        float convertResult = targetRateValue/baseTargetRate*number;
        return convertResult;
    }
}



@end
