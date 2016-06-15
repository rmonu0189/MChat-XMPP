//
//  AddBuddy.m
//  ChattingByJabber
//
//  Created by Monu Rathor on 11/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "AddBuddy.h"
#import "CreateCell.h"

@implementation AddBuddy
@synthesize txtGroupName;
@synthesize tableViewGroup;
@synthesize txtBuddyId;
@synthesize txtNixkName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    groupArray = [[NSMutableArray alloc]init];
    groupArray = [Connection sharedConnection].onlineGroupList;
    [self setTitle:@"Add Buddy"];
    tableViewGroup.dataSource = self;
    tableViewGroup.delegate = self;
    tableViewGroup.hidden = YES;
    txtGroupName.text = @"Main";
    [self setTitle:@"Add Buddy"];
    txtBuddyId.delegate = self;
    txtNixkName.delegate = self;
}

- (void)viewDidUnload
{
    [self setTxtBuddyId:nil];
    [self setTxtNixkName:nil];
    [self setTableViewGroup:nil];
    [self setTxtGroupName:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [Connection sharedConnection].alertDelegate = self.view;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)clickAddBuddy:(id)sender {
    if(([[txtBuddyId.text componentsSeparatedByString:@" "] count]<=1) && ([[txtBuddyId.text componentsSeparatedByString:@"@"] count]<=1) && ([[txtBuddyId.text componentsSeparatedByString:@"/"] count]<=1) && (![txtBuddyId.text isEqualToString:@""])){
        
        if([txtGroupName.text isEqualToString:@"Main"]){
            [[Connection sharedConnection] sendFriendRequestWithFriendID:txtBuddyId.text andNickName:txtNixkName.text];
        }
        else{
            [[Connection sharedConnection]inviteUserForGroupWithUserID:txtBuddyId.text message:@"Hi!, Please join me." FromRoom:txtGroupName.text];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Friend ID is wrong. Do not user blank space or nil and do not use \"@\" or \"/\" symbol." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)clickCancel:(id)sender {
    txtBuddyId.text = @"";
    txtNixkName.text = @"";
    txtGroupName.text = @"Main";
}


- (IBAction)clickChatRoom:(id)sender {
}

#pragma mark - Tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [groupArray count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    CreateCell *cell = [tableViewGroup dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil){
        cell = [[CreateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    cell.lblName.frame = CGRectMake(5, 3, 200, 25);
    cell.lblName.font=[UIFont fontWithName:@"Arial" size:18.0];
    if(indexPath.row == 0){
        cell.lblName.text = @"Main";
    }
    else{
        cell.lblName.text = [groupArray objectAtIndex:indexPath.row-1];
    }
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        txtGroupName.text = @"Main";
    }
    else{
        txtGroupName.text = [groupArray objectAtIndex:indexPath.row-1];
    }
    tableViewGroup.hidden = YES;
}

- (IBAction)clickDown:(id)sender {
    [self.view endEditing:YES];
    if(tableViewGroup.hidden == YES){
        tableViewGroup.hidden = NO;
    }
    else{
        tableViewGroup.hidden = YES;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    tableViewGroup.hidden = YES;
}

@end
