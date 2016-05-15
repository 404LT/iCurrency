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

@end

@implementation CurrencyManager


+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    static CurrencyManager *instant = nil;
    dispatch_once(&onceToken,^{
        instant = [[CurrencyManager alloc]init];
    });
    return instant;
}

- (NSArray *)allCurrencyCodes
{
//    return [self.currencies allKeys];
    return self.namesArray;
    
}

#pragma mark - 初始化的方法
- (id)init
{
//    [super init];
    //初始化一个用来存储自选国家的可变数组
    
    
    if (!_defaultsCountries) {
        _defaultsCountries = [[NSMutableArray alloc]initWithObjects:@"CNY",@"CAD", nil];
    }
    
    
    [self loadDisplay];
    
    
    
    NSLog(@"从JSON里面取出所有的汇率国家名称放在 namesArray和 displayArray里面");
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Names" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *namesDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *tempArray = [[NSArray alloc]initWithArray:[namesDic allKeys]copyItems:YES];

        _namesArray = [tempArray sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];

        _flagImage = [[NSMutableArray alloc]initWithCapacity:200];
        _currencyUnit = [[NSMutableArray alloc]initWithCapacity:200];
        
        for(NSString *name in _namesArray)
        {
            NSArray *array = namesDic[name];
            [_flagImage addObject:array[0]];
            [_currencyUnit addObject:array[1]];
        }
        
    }
    
    //在这个初始化方法里面把 defaultsCountries 数组给初始化出来
    //然后把它存储入系统的 userDefaults里面 以便下一次打开的时候使用
    //最后在addCurrencyVC里面添加的国家也存储到这个数组里面
    // namesArray[] flagImage[] currencyUnit[] 数组存储了所有的 国家名称 图片名称 货币单位
    
//    _allCurrenciesInfo =[NSMutableDictionary dictionaryWithObjectsAndKeys:_namesArray,_flagImage, nil];
    return self;
    
}

#pragma mark - 索引名次 图片 货币单位 -- 不要用这个方法
//- (NSArray *)allCurrencyCodes
//{
//    //    把plist里面所有的国家信息的键给存储在一个数组里面
//    return [self.currencies allKeys];
//}

- (UIImage *)imageForCountriesFlag:(NSString *)countryName
{
    UIImage *flag;
    NSDictionary *flagInfo = [self.currencies objectForKey:countryName];
    NSString *flagName = [flagInfo objectForKey:@"flag"];
    if (flagName) {
        flag = [UIImage imageNamed:flagName];
    }
    return flag;
}

- (NSString *)nameForCurrency:(NSString *)countryName
{
    //所有的信息都源自于currencies数组
    NSDictionary *nameInfo = [self.currencies objectForKey:countryName];
    return [nameInfo objectForKey:@"name"];
    
    //通过传入的countryName来检索数组里面的
    
}

- (NSString *)unitForCurrency:(NSString *)countryName
{
    NSDictionary *unitInfo = [self.currencies objectForKey:countryName];
    return [unitInfo objectForKey:@"unit"];
}


#pragma mark - 对defaultsCountries的一些操作

- (void)loadDisplay
{
    NSLog(@"加载用于展示的数组");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"Data.plist"];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiever = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        _defaultsCountries = [unarchiever decodeObjectForKey:@"defaultsArray"];
        [unarchiever finishDecoding];
    }
}

- (void)saveDisplay
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingString:@"Data.plist"];
    NSMutableData *data = [[NSMutableData alloc]initWithCapacity:300];
    NSKeyedArchiver *archiever = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiever encodeObject:_defaultsCountries forKey:@"defaultsCountries"];
    [archiever finishEncoding];
    [data writeToFile:filePath atomically:YES];
}


#pragma mark - 往存储显示国家的数组里面添加和删除国家名称的方法
// 添加自选货币，name是货币缩写
//用这个displayArray来管理自选的货币

- (void)addDisplayCurrencyName:(NSString *)name
{
    NSLog(@"添加选中的国家 %@",name);
    //防止多线程重复添加
    @synchronized(self) {
        if ([_defaultsCountries indexOfObject:name] == NSNotFound) {
            [_defaultsCountries addObject:name];
        }
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:name forKey:@"name" ];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Add" object:self userInfo:userInfo];
    [self saveDisplay];
}

//删除
- (void)removeDisplayCurrencyName:(NSString *)name
{
    NSLog(@"删除选中的国家 %@",name);
    @synchronized(self) {
        if ([_defaultsCountries indexOfObject:name] !=NSNotFound) {
            [_defaultsCountries removeObject:name];
        }
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:name forKeys:@"name" ];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Remove" object:self userInfo:userInfo];
    
    [self saveDisplay];
}


@end
