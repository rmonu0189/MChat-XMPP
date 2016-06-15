//
//  SetPhoto.m
//  mChat
//
//  Created by Mac22 on 09/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "SetPhoto.h"
#import "XMPPRosterCoreDataStorage.h"

@implementation SetPhoto
@synthesize imageViewBuddy;

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
    NSData *photodata = [[Connection sharedConnection]setPhotoWithID:[LoginUserInfo sharedLoginUserInfo].userID andRoomType:@"single"];
    if(photodata != nil){
        imageViewBuddy.image = [UIImage imageWithData:photodata];
    }
    else{
        imageViewBuddy.image = [UIImage imageNamed:@"defaultPerson.png"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setImageViewBuddy:nil];
    [super viewDidUnload];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageViewBuddy.image = img;
    [self dismissModalViewControllerAnimated:YES];
    XMPPRosterCoreDataStorage *roster = [[XMPPRosterCoreDataStorage alloc]init];
    [roster setPhoto:img forUserWithJID:[XMPPJID jidWithString:[LoginUserInfo sharedLoginUserInfo].userID] xmppStream:[Connection sharedConnection].xmppStream];
    
    
}

- (IBAction)clickChangePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
    else{
        NSLog(@"Photo Library not present");
    }
}
@end
