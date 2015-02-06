//
//  ChatTableViewCell.h
//  ParseChatClient
//
//  Created by Chinmay Kini on 2/5/15.
//  Copyright (c) 2015 Chinmay Kini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
