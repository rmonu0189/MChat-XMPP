//
//  CreateCell.h
//  ChattingByJabber
//
//  Created by Monu Rathor on 08/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateCell : UITableViewCell{
    UILabel *lblName;
    UILabel *lblDescription;
    UILabel *lblDate;
    UIImageView *imageView;
}
@property (nonatomic, retain) UILabel *lblDescription,*lblName,*lblDate;
@property (nonatomic, retain) UIImageView *imageView;

@end
