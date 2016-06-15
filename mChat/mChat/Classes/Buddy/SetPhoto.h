//
//  SetPhoto.h
//  mChat
//
//  Created by Mac22 on 09/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPhoto : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>{
    UIImagePickerController *picker;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBuddy;
- (IBAction)clickChangePhoto:(id)sender;

@end
