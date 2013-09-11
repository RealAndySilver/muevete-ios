//
//  FacebookShareViewController.m
//  Muevete
//
//  Created by Andres Abril on 7/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "FacebookShareViewController.h"
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
#define kRedColor [UIColor colorWithRed:250.0/255 green:88.0/255 blue:88.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]
@interface FacebookShareViewController ()

@end

@implementation FacebookShareViewController
@synthesize postParams;
- (void)viewDidLoad
{
    [super viewDidLoad];
    postParams = [@{   @"link" : @"https://developers.facebook.com/ios",
                       @"picture" : @"https://developers.facebook.com/attachment/iossdk_logo.png",
                       @"name" : @"Facebook SDK for iOS",
                       @"caption" : @"Build great social apps and get more installs.",
                       @"description" : @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps."
                       } mutableCopy];
    PullActionButton *backButton=[[PullActionButton alloc]initWithFrame:CGRectMake(-100, 0, 150, 44)];
    backButton.the_delegate=self;
    backButton.tag=1;
    backButton.icon.image=[UIImage imageNamed:@"left.png"];
    [backButton setColor:kRedColor];
    [backButton setHilightColor:kYellowColor];
    [self.view addSubview:backButton];
}
- (void)publishStory
{
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          result[@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}
- (IBAction)shareButtonAction:(id)sender {
    // Hide keyboard if showing when button clicked
//    if ([self.postMessageTextView isFirstResponder]) {
//        [self.postMessageTextView resignFirstResponder];
//    }
//    // Add user message parameter if user filled it in
//    if (![self.postMessageTextView.text
//          isEqualToString:kPlaceholderPostMessage] &&
//        ![self.postMessageTextView.text isEqualToString:@""]) {
//        self.postParams[@"message"] = self.postMessageTextView.text;
//    }
    
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         requestNewPublishPermissions:@[@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self publishStory];
             }
         }];
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - pull button delegate
-(void)actionAccepted:(int)tag{
    if (tag==1) {
        [self dismissViewController];
    }
}
#pragma mark - dismiss vc
-(void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
