//
//  Settings.m
//  mChat
//
//  Created by Mac22 on 09/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "Settings.h"
#import "DataStore.h"

@implementation Settings
@synthesize txtServer;
@synthesize txtConference,txtHostname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtServer.delegate = self;
    txtHostname.delegate = self;
    txtConference.delegate = self;
    DataStore *db = [[DataStore alloc]init];
    NSMutableArray *setting = [[NSMutableArray alloc]init];
    setting = [db showSettings];
    if(![setting count]==0){
        txtServer.text = [setting objectAtIndex:0];
        txtHostname.text = [setting objectAtIndex:1];
        txtConference.text = [setting objectAtIndex:2];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTxtServer:nil];
    [self setTxtHostname:nil];
    [self setTxtConference:nil];
    [super viewDidUnload];
}
- (IBAction)clickSave:(id)sender {
    DataStore *db = [[DataStore alloc]init];
    [db saveSettingWithServer:txtServer.text idHostName:txtHostname.text andConferenceHostname:txtConference.text];
    NSMutableArray *setting = [[NSMutableArray alloc]init];
    setting = [db showSettings];
    [[Connection sharedConnection] setServerSettingWithServerName:txtServer.text Hostname:txtHostname.text Conference:txtConference.text];
    [[Connection sharedConnection]alerMessageWithTitle:@"" Message:@"Server settings successfully saved."];
}

- (IBAction)clickClear:(id)sender {
    txtServer.text = @"";
    txtHostname.text = @"";
    txtConference.text = @"";
}
@end
