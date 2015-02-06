//
//  ChatViewController.m
//  ParseChatClient
//
//  Created by Chinmay Kini on 2/5/15.
//  Copyright (c) 2015 Chinmay Kini. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatTableViewCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (weak, nonatomic) IBOutlet UITextField *messageInputField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property ( strong, nonatomic)  NSMutableArray *chats;
- (IBAction)sendAction:(id)sender;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector: @selector(refreshChatTable) userInfo:nil repeats:YES];
    
    self.chatTable.dataSource = self;
    self.chatTable.delegate = self;
    
    self.title                  = @"Chat up";
    [self.chatTable registerNib:[UINib nibWithNibName:@"ChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChatTableViewCell"];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableview methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatTableViewCell *cell             = [tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell"];
    NSDictionary *chatMessage = self.chats[indexPath.row];
    cell.chatLabel.text = chatMessage[@"text"];
    PFUser *user;
    
    if ([ chatMessage[@"user"] isKindOfClass:[PFUser class]] ) {
        user = chatMessage[@"user"];
        cell.nameLabel.text = user.username    ;
    }
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.chats.count;
    
}


- (IBAction)sendAction:(id)sender {
    PFObject *gameScore = [PFObject objectWithClassName:@"Message"];
    gameScore[@"text"] = self.messageInputField.text;
    gameScore[@"user"] = [PFUser currentUser];
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Sent:  %@ ", self.messageInputField.text);
            // The object has been saved.
            self.messageInputField.text = @"";
        } else {
            NSString *errorString = [error userInfo][@"error"];

            NSLog(@"Error Sending :  %@  Error: %@", self.messageInputField.text, errorString);

            // There was a problem, check error.description
        }
    }];
}

-(void)refreshChatTable{
    
    // refresh teh chat table
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
//    [query whereKey:@"text" equalTo:@"Dan Stemkoski"];
//    [query whereKey:@"text" equalTo:@"Dan Stemkoski"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            self.chats = [NSMutableArray array];
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object[@"text"]);
                NSString *user = @"";
                if ( object [@"user"] ) {
                    user = object [@"user"];
                    NSLog(@"%@" , user);
                }
                NSDictionary *chatMessage = @{@"user" : user, @"text" : object[@"text"]};
                [self.chats addObject:chatMessage];
            }
            [self.chatTable reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
