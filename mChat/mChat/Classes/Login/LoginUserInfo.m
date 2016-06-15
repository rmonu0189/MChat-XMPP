//
//  LoginUserInfo.m
//  mChat
//
//  Created by Monu Rathor on 03/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "LoginUserInfo.h"

@implementation LoginUserInfo
@synthesize userID,password,userType,hostName;
static LoginUserInfo* _sharedStoreLoginUserInfo;

+ (id)alloc {
	@synchronized([LoginUserInfo class]) {
		NSAssert(_sharedStoreLoginUserInfo == nil, @"Attempted to allocate a second instance of singleton class MusicPlayers.");
		_sharedStoreLoginUserInfo = [super alloc];
		return _sharedStoreLoginUserInfo;
	}
	return nil;
    
}

+ (LoginUserInfo*)sharedLoginUserInfo
{
	@synchronized(self) {
		
        if (_sharedStoreLoginUserInfo == nil) {
            [[self alloc] init];
        }
    }
    return _sharedStoreLoginUserInfo;
}

@end
