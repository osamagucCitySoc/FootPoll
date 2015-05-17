//
//  ResetPasswordViewController.m
//  FootPoll
//
//  Created by Osama Rabie on 5/11/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "CRToastManager.h"
#import "CRToast.h"
#import "AFHTTPRequestOperationManager.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>

@interface ResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.layer.borderColor = [[UIColor alloc]initWithWhite:1 alpha:1].CGColor;
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:22];
   
    self.hintLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    
    self.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:18];
    
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"البريد الإلكتروني" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.691 green:0.691 blue:0.691 alpha:1]}];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissClicked:(id)sender {
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.75;
    transition.type = kCATransitionFade;
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)resetButtonClicked:(id)sender {
    
    self.bouncingBalls = [PQFBouncingBalls createModalLoader];
    self.bouncingBalls.jumpAmount = 50;
    self.bouncingBalls.zoomAmount = 20;
    self.bouncingBalls.separation = 20;
    [self.bouncingBalls showLoader];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"userEmail": self.userNameTextField.text};
    [manager POST:@"http://moh2013.com/arabDevs/FootPoll/resetPassword.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.bouncingBalls removeLoader];
        NSString* message = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *options = @{
                                  kCRToastTextKey : message,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.bouncingBalls removeLoader];
        NSLog(@"Error: %@", error);
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
