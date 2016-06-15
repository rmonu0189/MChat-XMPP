//
//  Message.h
//  mChat
//
//  Created by Monu Rathor on 04/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
{
    NSString *messageBody;
    NSString *type;//receive or send
    NSString *from;
}
@property (nonatomic, retain) NSString *messageBody,*from,*type;
@end
