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
        NSLog(@"init-Rates is %@",self.rates);
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
//    NSLog(@"save-rates is %@",self.rates);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"rateDic"];
    NSMutableData *data = [[NSMutableData alloc]initWithCapacity:500];
    NSKeyedArchiver *archiever = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiever encodeObject:_rates forKey:@"rates"];
    [archiever finishEncoding];
    [data writeToFile:filePath atomically:YES];
    
}

#pragma mark - 汇率的一些操作

- (BOOL)save
{
    //NSLog(@"存起来");
    BOOL result = [NSKeyedArchiver archiveRootObject:self toFile:[ExchangeRate filePath]];
   // NSLog(@"load-rates %@",self.rates);//YES
    return result;
}
+ (ExchangeRate *)load
{
    NSLog(@"load");
    //把存储在本地document当中的rates给加载出来
    ExchangeRate *rate = [NSKeyedUnarchiver unarchiveObjectWithFile:[ExchangeRate filePath]];
    
    return rate;
}
+(NSString *)filePath
{
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [docsPath stringByAppendingString:@"rates"];
  //  NSLog(@"filePath is %@",filePath);
    
    return filePath;
}


#pragma mark - 转换方法
- (double)convertRate:(NSString *)baseCurrencyName
                   to:(NSString *)targetCurrencyName
                 with:(float)number
{
    NSLog(@"换算中~~~~~~ rates is ：%@", self.rates);
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
#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.rates = [aDecoder decodeObjectForKey:kKeyRates];
    }
    // NSLog(@"initWithCoder 数组已有内容");//YES
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.rates forKey:kKeyRates];
    // NSLog(@"load-rates %@",self.rates);//YES
    NSLog(@"用来归档 ");
}
//}

@end
