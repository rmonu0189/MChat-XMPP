//
//  GroupRoomData.h
//  ChattingByJabber
//
//  Created by Monu Rathor on 21/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupRoomData : NSObject
{
    NSString *groupName;
    NSString *userName;
}
@property (nonatomic, retain) NSString *groupName,*userName;

@end
