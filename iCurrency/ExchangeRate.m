//
//  ExchangeRate.m
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import "ExchangeRate.h"

NSString *const kKeyBaseCurrencyName = @"baseCurrencyName";
NSString *const kKeyRates = @"rates";
NSString *const kKeyLastUpdated = @"lastUpdated";


@implementation ExchangeRate

- (instancetype)init{
    
    if (self = [super init]) {
        _rates = [[NSMutableDictionary alloc]initWithCapacity:500];
        //写两个方法来初始化汇率字典
        [self loadRates];
    }
    return self;
}
#pragma mark - loadRates & initRates
- (void)loadRates
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"rateDic"];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        _rates = [unarchiver decodeObjectForKey:@"rates"];
        [unarchiver finishDecoding];
    }
    
}

- (void)saveRates
{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"rateDic"];
    NSMutableData *data = [[NSMutableData alloc]initWithCapacity:500];
    NSKeyedArchiver *archiever = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiever encodeObject:_rates forKey:@"rates"];
    [archiever finishEncoding];
    [data writeToFile:filePath atomically:YES];
    
}

#pragma mark - 转换方法
- (double)convertRate:(NSString *)baseCurrencyName
                   to:(NSString *)targetCurrencyName
                 with:(float)number
{
//    NSLog(@"换算中~~~~~~ rates is ：%@", self.rates);
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
