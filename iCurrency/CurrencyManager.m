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
   // NSLog(@"模型层-sharedInstance is called");
    static dispatch_once_t onceToken;
    static CurrencyManager *instant = nil;
    dispatch_once(&onceToken,^{
        
        instant = [[CurrencyManager alloc]init];
    });
    return instant;
}

#pragma mark - 初始化的方法
- (instancetype)init
{
    if (self = [super init])
    {
    _defaultsCountries = [[NSMutableArray alloc]initWithCapacity:200];
    
    [self loadDisplay];
    [self initCurrencyInfo];
        
    NSLog(@"2defaultsCountries2 is %@",_defaultsCountries);
     

    
    }
    return self;
    
}

- (void)initCurrencyInfo
{
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

#pragma mark - 对defaultsCountries的一些操作

- (void)loadDisplay
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"Data.plist"];
    
//    NSLog(@"filePath is %@",filePath);
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiever = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        _defaultsCountries = [unarchiever decodeObjectForKey:@"defaultsCountries"];
        [unarchiever finishDecoding];
        
//        NSLog(@"load操作 is %@",_defaultsCountries);
    }
}

- (void)saveDisplay
{
    //这个方法没问题
    NSLog(@"向本地写入文件");
    NSLog(@"defaultsCountries3 is %@",self.defaultsCountries);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"Data.plist"];
    NSMutableData *data = [[NSMutableData alloc]initWithCapacity:300];
    NSKeyedArchiver *archiever = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [archiever encodeObject:_defaultsCountries forKey:@"defaultsCountries"];
    [archiever finishEncoding];
    [data writeToFile:filePath atomically:YES];
    NSLog(@"Archiver 数据已存储.");
}
#pragma mark - <NSCoding>
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    //解档
//    NSLog(@"解档");
//    if (self=[super init]) {
//        self.defaultsCountries = [aDecoder decodeObjectForKey:@"defaultsCountries"];
//        
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    NSLog(@"归档");
//    [aCoder encodeObject:_defaultsCountries forKey:@"defaultsCountries"];
//    
//}



#pragma mark - 往存储显示国家的数组里面添加和删除国家名称的方法
// 添加自选货币，name是货币缩写
//用这个displayArray来管理自选的货币

- (void)addDisplayCurrencyName:(NSString *)name
{
    //_defaultsCountries = [[NSMutableArray alloc]initWithCapacity:200];
   //如果这样的话 每次都会初始化一个数组。。。
    
    
//    NSLog(@"1-defalutsCountries is %@",self.defaultsCountries);
    //防止多线程重复添加
    @synchronized(self)
    {
        if ([_defaultsCountries indexOfObject:name] == NSNotFound)
        {
            [_defaultsCountries addObject:name];
        }
    }
    
    NSLog(@"add操作 is %@",_defaultsCountries);
    
    [self saveDisplay];
    
}

//删除
- (void)removeDisplayCurrencyName:(NSString *)name
{
    NSLog(@"模型层-删除选中的国家 %@",name);
    @synchronized(self) {
        if ([_defaultsCountries indexOfObject:name] !=NSNotFound) {
            [_defaultsCountries removeObject:name];
        }
    }
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:name forKey:@"name"];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"Remove" object:self userInfo:userInfo];
   
    [self saveDisplay];
}

- (NSArray *)allCurrencyCodes
{
    //返回所有一个存有 所有国家名称 的数组
    return self.namesArray;
    
}

@end
