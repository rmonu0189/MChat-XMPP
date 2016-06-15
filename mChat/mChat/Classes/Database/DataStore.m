//
//  DataStore.m
//  ChattingByJabber
//
//  Created by Monu Rathor on 21/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "DataStore.h"
#import "sqlite3.h"
#import "GroupRoomData.h"

@implementation DataStore

sqlite3 *empDB;
const char *dbPath;
const char *queryStatement;


- (NSString *)findPath{
    NSString *databaseName = @"Chatting.sqlite";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:databasePath];
    
    if(!success) {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    return databasePath;
}

- (void)openConnection{
    const char *dbPath = [[self findPath]  UTF8String];
    int dbResult = sqlite3_open(dbPath,&empDB);
    if(dbResult == SQLITE_OK){
        //NSLog(@"Database open Successfully.");
    }
}

- (void)AddGroupRoomWithName:(NSString *)groupName UserName:(NSString *)userName{
    [self openConnection];
    sqlite3_stmt *statement;
    NSString *querySql =[NSString stringWithFormat:@"insert into GroupRoom(userName,roomName) values('%@','%@');",userName,groupName];
    
    const char *query_Stmt1 = [querySql UTF8String];
    NSLog(@"%s",query_Stmt1);
    int res = sqlite3_prepare_v2(empDB, query_Stmt1, -1, &statement,NULL);
    //NSLog(@"result1 %d",res);
    if (res==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_DONE) {}
        NSLog(@"Data inserted successfully.");
    }
    else{
        
        NSLog(@"Problem with prepare statement.");
    }
    sqlite3_finalize(statement);
    sqlite3_close(empDB);
}

- (NSMutableArray *)showAllGroupRoomWithUserName:(NSString *)user{
    NSMutableArray *record = [[NSMutableArray alloc]init];
    [self openConnection];    
    sqlite3_stmt *statement;
    NSString *querySql = [NSString stringWithFormat:@"select * from GroupRoom where userName='%@'",user];
    //NSString *querySql = @"delete from GroupRoom";
    const char *query_Stmt = [querySql UTF8String];
    //NSLog(@"%s",query_Stmt);
    int res = sqlite3_prepare_v2(empDB, query_Stmt, -1, &statement,NULL);
    ////NSLog(@"result1 %d",res);
    if (res!=SQLITE_OK){
        NSLog(@"\n\n@@@@@@@\nProblem with prepare statement.\n@@@@@@\n\n");
    }
    else{        
        while(sqlite3_step(statement)==SQLITE_ROW){
            GroupRoomData *groupRoomData = [[GroupRoomData alloc]init];
            groupRoomData.userName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)];
            groupRoomData.groupName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
            [record addObject:groupRoomData];
            NSLog(@"\n\n%%%%%%%%\nDatastore roomName:%@",groupRoomData.groupName);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(empDB);
    return record;
}

- (void)deleteRoomWithGroupID:(NSString *)groupName{
    [self openConnection];
    sqlite3_stmt *statement;
    NSString *querySql =[NSString stringWithFormat:@"delete from GroupRoom where roomName='%@'",groupName];
    
    const char *query_Stmt1 = [querySql UTF8String];
    NSLog(@"%s",query_Stmt1);
    int res = sqlite3_prepare_v2(empDB, query_Stmt1, -1, &statement,NULL);
    //NSLog(@"result1 %d",res);
    if (res==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_DONE) {}
        NSLog(@"Data delete successfully.");
    }
    else{
        
        NSLog(@"Problem with prepare statement.");
    }
    sqlite3_finalize(statement);
    sqlite3_close(empDB);
}

- (NSMutableArray *)showSettings{
    NSMutableArray *record = [[NSMutableArray alloc]init];
    [self openConnection];
    sqlite3_stmt *statement;
    NSString *querySql = @"select * from ServerSettings";
    const char *query_Stmt = [querySql UTF8String];
    int res = sqlite3_prepare_v2(empDB, query_Stmt, -1, &statement,NULL);
    if (res!=SQLITE_OK){
        NSLog(@"\n\n@@@@@@@\nProblem with prepare statement.\n@@@@@@\n\n");
    }
    else{
        while(sqlite3_step(statement)==SQLITE_ROW){
            [record addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)]];
            [record addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)]];
            [record addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)]];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(empDB);
    return record;
}

- (void)deleteServersetting{
    [self openConnection];
    sqlite3_stmt *statement;
    NSString *querySql =@"delete from ServerSettings";
    
    const char *query_Stmt1 = [querySql UTF8String];
    NSLog(@"%s",query_Stmt1);
    int res = sqlite3_prepare_v2(empDB, query_Stmt1, -1, &statement,NULL);
    //NSLog(@"result1 %d",res);
    if (res==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_DONE) {}
        NSLog(@"Data inserted successfully.");
    }
    else{
        
        NSLog(@"Problem with prepare statement.");
    }
    sqlite3_finalize(statement);
    sqlite3_close(empDB);
}

- (void)saveSettingWithServer:(NSString *)server idHostName:(NSString *)isHostName andConferenceHostname:(NSString *)conference{
    [self deleteServersetting];
    [self openConnection];
    sqlite3_stmt *statement;
    NSString *querySql =[NSString stringWithFormat:@"insert into ServerSettings(serverName,idHostname,conference) values('%@','%@','%@')",server,isHostName,conference];
    
    const char *query_Stmt1 = [querySql UTF8String];
    NSLog(@"%s",query_Stmt1);
    int res = sqlite3_prepare_v2(empDB, query_Stmt1, -1, &statement,NULL);
    //NSLog(@"result1 %d",res);
    if (res==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_DONE) {}
        NSLog(@"Data inserted successfully.");
    }
    else{
        
        NSLog(@"Problem with prepare statement.");
    }
    sqlite3_finalize(statement);
    sqlite3_close(empDB);
}

@end
