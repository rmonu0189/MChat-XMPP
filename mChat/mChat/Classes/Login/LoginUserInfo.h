//
//  LoginUserInfo.h
//  mChat
//
//  Created by Monu Rathor on 03/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUserInfo : NSObject
{
    NSString *userID;
    NSString *password;
    NSString *userType;  //login or register
    NSString *hostName;
}
@property (nonatomic, retain) NSString *hostName;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *password,*userType;
+ (LoginUserInfo*)sharedLoginUserInfo;
@end
