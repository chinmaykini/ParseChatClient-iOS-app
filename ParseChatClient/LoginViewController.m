//
//  LoginViewController.m
//  ParseChatClient
//
//  Created by Chinmay Kini on 2/5/15.
//  Copyright (c) 2015 Chinmay Kini. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "ChatViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *SignupField;
@property (weak, nonatomic) IBOutlet UIButton *signInField;
- (IBAction)onSignupButton:(id)sender;
- (IBAction)onSignInButton:(id)sender;

-(void) refreshChatTable;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

- (IBAction)onSignupButton:(id)sender {
    
    PFUser *user = [PFUser user];
    user.username = self.emailField.text;
    user.password = self.passwordField.text;
//    user.email = @"email@example.com";
    
    // other fields can be set just like with PFObject
//    user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"user %@ signed up", self.emailField.text);
            ChatViewController *vc = [[ChatViewController alloc] init];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
            nvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nvc animated:YES completion:nil];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"user %@ errored out during sign up with error %@", self.emailField.text, errorString);

        }
    }];
}

- (IBAction)onSignInButton:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"user %@ logged in", self.emailField.text);
                                            ChatViewController *vc = [[ChatViewController alloc] init];
                                            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
                                            nvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                            [self presentViewController:nvc animated:YES completion:nil];

                                        } else {
                                            // The login failed. Check error to see why.
                                            NSString *errorString = [error userInfo][@"error"];
                                             NSLog(@"user %@ logging failed with error %@", self.emailField.text, errorString);
                                
                                        }
                                    }];
  
}
@end
