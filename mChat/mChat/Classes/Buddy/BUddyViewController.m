//
//  BUddyViewController.m
//  mChat
//
//  Created by Monu Rathor on 04/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "BUddyViewController.h"
#import "BuddyInfo.h"
#import "CreateCell.h"
#import "AddBuddy.h"
#import "AddGroup.h"
#import "ChatView.h"
#import "DataStore.h"
#import "SetPhoto.h"

@implementation BUddyViewController
@synthesize tableViewBuddy;
@synthesize xmppRoster;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)reloadBuddyList{
    [tableViewBuddy reloadData];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([actionSheet.title isEqualToString:@"Select one"]){
        if(buttonIndex == 0){
            AddBuddy *addBuddy = [[AddBuddy alloc]init];
            [self.navigationController pushViewController:addBuddy animated:YES];
        }
        else if(buttonIndex == 1){
            AddGroup *addGroup = [[AddGroup alloc]init];
            [self.navigationController pushViewController:addGroup animated:YES];
        }
        else if(buttonIndex == 2){
            SetPhoto *setPhoto = [[SetPhoto alloc]init];
            [self.navigationController pushViewController:setPhoto animated:YES];
        }
    }
    else{
        if(buttonIndex == 0){
            [[Connection sharedConnection] goOffline];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)clickLogout{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Are you sure." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

- (void)clickAdd{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select one" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Add Buddy" otherButtonTitles:@"Add Group", @"Set Photo",nil];
    [actionSheet showInView:self.view];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    buttonAddUser = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAdd)];
    self.navigationItem.rightBarButtonItem = buttonAddUser;
    buttonLogout = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(clickLogout)];
    self.navigationItem.leftBarButtonItem = buttonLogout;
    
    [Connection sharedConnection].buddyViewControllerDelegate = self;
    tableViewBuddy.dataSource = self;
    tableViewBuddy.delegate = self;
    self.navigationItem.hidesBackButton = YES;
    [self setTitle:@"mChat"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Connection sharedConnection].alertDelegate = self.view;
    //[self reloadBuddyList];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [[Connection sharedConnection].onlineBuddyList count];
    }
    else if(section == 1){
        return 0;
    }
    else{
        return [[Connection sharedConnection].onlineGroupList count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    CreateCell *cell = [tableViewBuddy dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil){
        cell = [[CreateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    if(indexPath.section == 0){
        NSData *photoData = [[Connection sharedConnection] setPhotoWithID:[[Connection sharedConnection].onlineBuddyList objectAtIndex:indexPath.row] andRoomType:@"single"];
        if(photoData != Nil){
            cell.imageView.image = [UIImage imageWithData:photoData];
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"defaultPerson.png"];
        }
        cell.lblName.text = [[Connection sharedConnection].onlineBuddyList objectAtIndex:indexPath.row];
    }
    if(indexPath.section == 2){
        NSData *photoData = [[Connection sharedConnection] setPhotoWithID:[[Connection sharedConnection].onlineGroupList objectAtIndex:indexPath.row] andRoomType:@"group"];
        if(photoData != Nil){
            cell.imageView.image = [UIImage imageWithData:photoData];
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"defaultPerson.png"];
        }
        cell.lblName.text = [[Connection sharedConnection].onlineGroupList objectAtIndex:indexPath.row];
    }
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"Online Buddy";
    }
    else if(section == 1){
        return @"";
    }
    else{
        return @"Online Group";
    }
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatView *chatView = [[ChatView alloc]init];
    [self.navigationController pushViewController:chatView animated:YES];
    if(indexPath.section==0){
        [Connection sharedConnection].chattingType = @"single";
        [Connection sharedConnection].currentChattingBuddy = [[Connection sharedConnection].onlineBuddyList objectAtIndex:indexPath.row];
    }
    else if(indexPath.section==2){
        [Connection sharedConnection].chattingType = @"group";
        [Connection sharedConnection].currentChattingBuddy = [[Connection sharedConnection].onlineGroupList objectAtIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if(indexPath.section==0){
            [[Connection sharedConnection]deleteBuddyWithBuddyID:[[Connection sharedConnection].onlineBuddyList objectAtIndex:indexPath.row]];
            [Connection sharedConnection].unsybscribeBuddyID = [NSString stringWithFormat:@"%@%@",[[Connection sharedConnection].onlineBuddyList objectAtIndex:indexPath.row],[Connection sharedConnection].idHostName];
            [[Connection sharedConnection].onlineBuddyList removeObjectAtIndex:indexPath.row];
        }
        else if(indexPath.section==2){
            [[Connection sharedConnection] deleteRoomWithRoomID:[[Connection sharedConnection].onlineGroupList objectAtIndex:indexPath.row]];
            DataStore *db = [[DataStore alloc]init];
            [db deleteRoomWithGroupID:[NSString stringWithFormat:@"%@%@",[[Connection sharedConnection].onlineGroupList objectAtIndex:indexPath.row],[Connection sharedConnection].conferenceHostName]];
            [[Connection sharedConnection].onlineGroupList removeObjectAtIndex:indexPath.row];
        }
        [tableViewBuddy reloadData];
    }
}

@end
