//
//  AppDelegate.h
//  mChat
//
//  Created by Monu Rathor on 03/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

@end
