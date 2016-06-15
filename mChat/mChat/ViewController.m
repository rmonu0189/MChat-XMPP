//
//  ViewController.m
//  mChat
//
//  Created by Monu Rathor on 03/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "ViewController.h"
#import "Registration.h"
#import "BUddyViewController.h"
#import "Settings.h"
#import "DataStore.h"

@implementation ViewController
@synthesize txtUserID;
@synthesize txtPassword;
@synthesize indicator;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)clickSettings{
    Settings *setting = [[Settings alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtPassword.secureTextEntry = YES;
    [Connection sharedConnection].viewControllerDelegate = self;
    [Connection sharedConnection].alertDelegate = self.view;
    indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    UIView *indicatorImageView = [[UIView alloc]initWithFrame:CGRectMake(80, 80, 160, 120)];
    indicatorImageView.backgroundColor = [UIColor blackColor];
    indicatorImageView.alpha = 0.9;
    indicator.center = CGPointMake(80, 70);
    [indicatorImageView addSubview:indicator];
    UILabel *indicatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 200, 30)];
    indicatorLabel.text = @"Please wait....";
    indicatorLabel.textColor = [UIColor whiteColor];
    indicatorLabel.backgroundColor = [UIColor clearColor];
    [indicatorImageView addSubview:indicatorLabel];
    [indicatorView addSubview:indicatorImageView];
    [self setTitle:@"mChat"];
    txtUserID.delegate = self;
    txtPassword.delegate = self;
    barButtonSetting = [[UIBarButtonItem alloc]initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(clickSettings)];
    self.navigationItem.rightBarButtonItem = barButtonSetting;
    DataStore *db = [[DataStore alloc]init];
    NSMutableArray *setting = [[NSMutableArray alloc]init];
    setting = [db showSettings];
    if([setting count]==0){
        [[Connection sharedConnection] setServerSettingWithServerName:@"" Hostname:@"" Conference:@""];
    }
    else{
        [[Connection sharedConnection] setServerSettingWithServerName:[setting objectAtIndex:0] Hostname:[setting objectAtIndex:1] Conference:[setting objectAtIndex:2]];
    }
}

- (void)viewDidUnload
{
    [self setTxtUserID:nil];
    [self setTxtPassword:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [LoginUserInfo sharedLoginUserInfo].userType = @"login";
    txtUserID.text = [[[LoginUserInfo sharedLoginUserInfo].userID componentsSeparatedByString:@"@"]objectAtIndex:0];
    txtPassword.text = @"";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [LoginUserInfo sharedLoginUserInfo].userType = @"";
    txtPassword.text = @"";
    txtUserID.text = @"";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)clickRegistration:(id)sender {
    Registration *registration = [[Registration alloc]init];
    [self.navigationController pushViewController:registration animated:YES];
}

- (void)showBuddyViewController{
    BUddyViewController *buddyView = [[BUddyViewController alloc]init];
    [self.navigationController pushViewController:buddyView animated:YES];
}

- (void)stopIndicator{
    if([indicator isAnimating]){
        [indicator stopAnimating];
        [indicatorView removeFromSuperview];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)clickLogin:(id)sender {
    [self.view endEditing:YES];
    [self.view addSubview:indicatorView];
    [indicator startAnimating];
    [[Connection sharedConnection]loginUserWithUserID:txtUserID.text andPassword:txtPassword.text];
}
@end
