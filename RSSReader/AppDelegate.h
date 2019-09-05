//
//  AppDelegate.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/26/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

