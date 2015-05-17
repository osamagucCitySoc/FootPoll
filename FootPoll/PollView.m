//
//  PollView.m
//  FootPoll
//
//  Created by Osama Rabie on 5/13/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "PollView.h"
#import "CRToastManager.h"
#import "CRToast.h"
#import "AFHTTPRequestOperationManager.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>

@implementation PollView
{
    PQFBouncingBalls *bouncingBalls;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (id)initWithNib
{
    // where MyCustomView is the name of your nib
    UINib *nib = [UINib nibWithNibName:@"PollView" bundle:[NSBundle mainBundle]];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    return self;
}
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if(self){
        // do your initialization tasks here
    }
    return self;
}
- (void)awakeFromNib
{
    
}

-(void)initUI
{
    
    self.clubOneName.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    self.clubTwoName.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
    
    
    self.submitButton.layer.borderWidth = 1;
    self.submitButton.layer.cornerRadius = 10;
    self.submitButton.layer.borderColor = [[UIColor alloc]initWithWhite:1 alpha:1].CGColor;
    self.submitButton.titleLabel.font = [UIFont fontWithName:@"DroidArabicKufi-bold" size:12];
}

- (IBAction)decreaseClubOneClicked:(id)sender {
    
    
    if([[self.clubOneScore text] isEqualToString:@"-"])
    {}else
    {
        int clubOne = [[self.clubOneScore text] intValue];
        clubOne--;
        if(clubOne < 0)
        {
            clubOne = 0;
        }
        [self.clubOneScore setText:[NSString stringWithFormat:@"%i",clubOne]];
    }
}

- (IBAction)increaseClubOneClicked:(id)sender {
    if([[self.clubOneScore text] isEqualToString:@"-"])
    {
        int clubOne = 0;
        [self.clubOneScore setText:[NSString stringWithFormat:@"%i",clubOne]];
        
    }else
    {
        int clubOne = [[self.clubOneScore text] intValue];
        clubOne++;
        [self.clubOneScore setText:[NSString stringWithFormat:@"%i",clubOne]];
    }
    
}

- (IBAction)increaseClubTwoClicked:(id)sender {
    
    if([[self.clubOneScore text] isEqualToString:@"-"])
    {
        int clubOne = 0;
        [self.clubTwoScore setText:[NSString stringWithFormat:@"%i",clubOne]];
        
    }else
    {
        int clubOne = [[self.clubTwoScore text] intValue];
        clubOne++;
        [self.clubTwoScore setText:[NSString stringWithFormat:@"%i",clubOne]];
    }
}

- (IBAction)decreaseClubTwoClicked:(id)sender {
    if([[self.clubOneScore text] isEqualToString:@"-"])
    {}else
    {
        int clubOne = [[self.clubTwoScore text] intValue];
        clubOne--;
        if(clubOne < 0)
        {
            clubOne = 0;
        }
        
        [self.clubTwoScore setText:[NSString stringWithFormat:@"%i",clubOne]];
    }
    
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    [UIView animateWithDuration:0.5
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rect = self.frame;
                         rect.origin.x = rect.size.width+10;
                         self.alpha = 0;
                         self.frame = rect;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    
}
- (IBAction)submitButtonClicked:(id)sender {
 
    if([self.clubOneScore.text isEqualToString:@"-"] || [self.clubTwoScore.text isEqualToString:@"-"])
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : @"يجب إدخال النتائج للفريقين",
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

    }else
    {
        bouncingBalls = [PQFBouncingBalls createModalLoader];
        bouncingBalls.jumpAmount = 50;
        bouncingBalls.zoomAmount = 20;
        bouncingBalls.separation = 20;
        [bouncingBalls showLoader];

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary* params = @{@"gameID":self.gameID,@"userID":self.userID,@"score":[NSString stringWithFormat:@"%@-%@",self.clubOneScore.text,self.clubTwoScore.text]};
        
        [manager POST:@"http://moh2013.com/arabDevs/FootPoll/submitVoteForGame.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [bouncingBalls removeLoader];
            
            [UIView animateWithDuration:0.5
                                  delay: 0
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 CGRect rect = self.frame;
                                 rect.origin.x = rect.size.width+10;
                                 self.alpha = 0;
                                 self.frame = rect;
                             }
                             completion:^(BOOL finished){
                                 [self removeFromSuperview];
                             }];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [bouncingBalls removeLoader];
            NSLog(@"Error: %@", error);
        }];
    }
}
@end
