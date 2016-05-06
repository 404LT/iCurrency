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

//+ (instancetype)default
//{
//    static CurrencyManager *_manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _manager = [[CurrencyManager alloc] init];
//    });
//    return _manager;
//}

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    static CurrencyManager *instant = nil;
    dispatch_once(&onceToken,^{
        instant = [[CurrencyManager alloc]init];
    });
    return instant;
}


#pragma mark - 索引名次 图片 货币单位
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
    //所有的信息都源自于currencies数组
    NSDictionary *nameInfo = [self.currencies objectForKey:countryName];
    return [nameInfo objectForKey:@"name"];
}

- (NSString *)unitForCurrency:(NSString *)countryName
{
//    NSLog(@"设置界面显示的货币单位");
    NSDictionary *unitInfo = [self.currencies objectForKey:countryName];
    return [unitInfo objectForKey:@"unit"];
}

- (id)init
{
    /*
    NSLog(@"从plist里面取出汇率相关的属性放在currencies里面");
    self = [super init];
    if (self) {
        NSString * plist = [[NSBundle mainBundle]pathForResource:@"currencies" ofType:@"plist"];
        self.currencies = [NSDictionary dictionaryWithContentsOfFile:plist];
        //从plist里面取出当前国家的 名称 国旗 货币单位放在currencies 里面
        //        NSLog(@"currencies里面的内容的是~~~%@",self.currencies);
    }
    return self;
    
    */
    NSLog(@"init is called");
    NSLog(@"从JSON里面取出所有的汇率国家名称放在 namesArray和 displayArray里面");
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Names" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *namesDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *tempArray = [[NSArray alloc]initWithArray:[namesDic allKeys]copyItems:YES];
//        NSLog(@"此时namesDic里面的内容是：%@",namesDic);
        
        
        _namesArray = [tempArray sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
//        NSLog(@"此时namesDic里面的内容是：%@",self.namesArray);
        
        //分别用两个数组来存放 国旗图片的名字 和 货币单位
        
        //namesArray
        //flagImage
        //currencyUnit
        
        _flagImage = [[NSMutableArray alloc]initWithCapacity:200];
        _currencyUnit = [[NSMutableArray alloc]initWithCapacity:200];
        
        for(NSString *name in _namesArray)
        {
            NSArray *array = namesDic[name];
            [_flagImage addObject:array[0]];
            [_currencyUnit addObject:array[1]];
        }
        
    }
    
    if (self.namesArray && self.flagImage && self.currencyUnit) {
        NSLog(@"这几个数组里面都有内容");
    }
    else
    {
        NSLog(@"这几个数组没有内容");
    }
//    NSLog(@"1%@",self.namesArray);
//    NSLog(@"2%@",self.flagImage);
//    NSLog(@"3%@",self.currencyUnit);
    
    return self;
    
}

- (void)initLocalNameSortList
{
    //初始化本地国家名称检索表
    //解析那个Names.json
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Names" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSDictionary *namesDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *tempArray = [[NSArray alloc]initWithArray:[namesDic allKeys]copyItems:YES];
    

    //_xxx访问内存地址，建议在一些初始化init方法里面使用_init,其他方法里面使用self.xxx
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



@end
