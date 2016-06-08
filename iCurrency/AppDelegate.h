//
//  AppDelegate.h
//  iCurrency
//
//  Created by 陆文韬 on 16/2/23.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define TOP_COLOR [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];

#define BASIC_COLOR [UIColor colorWithRed:151.0/255.0 green:255.0/255.0 blue:226.0/255.0 alpha:1.0];

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

