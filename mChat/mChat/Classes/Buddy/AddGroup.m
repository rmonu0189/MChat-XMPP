//
//  AddGroup.m
//  ChattingByJabber
//
//  Created by Monu Rathor on 18/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "AddGroup.h"

@implementation AddGroup
@synthesize txtGroupName;

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
    txtGroupName.text = @"";
    [self setTitle:@"Add Group"];
    txtGroupName.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)viewDidUnload
{
    [self setTxtGroupName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Connection sharedConnection].alertDelegate = self.view;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickAddGroup:(id)sender {
    if(([[txtGroupName.text componentsSeparatedByString:@" "] count]<=1) && ([[txtGroupName.text componentsSeparatedByString:@"@"] count]<=1) && ([[txtGroupName.text componentsSeparatedByString:@"/"] count]<=1) && (![txtGroupName.text isEqualToString:@""])){
        [[Connection sharedConnection] createOrJoinRoomWithRoomName:txtGroupName.text NickName:@""];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Friend ID is wrong. Do not user blank space or nil and do not use \"@\" or \"/\" symbol." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)clickClear:(id)sender {
    txtGroupName.text = @"";
}


@end
