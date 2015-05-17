//
//  PollView.h
//  FootPoll
//
//  Created by Osama Rabie on 5/13/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PollView : UIView

- (id)initWithNib;
-(void)initUI;

@property (weak, nonatomic) IBOutlet UILabel *clubTwoName;
@property (weak, nonatomic) IBOutlet UIImageView *clubTwoFlag;
@property (weak, nonatomic) IBOutlet UIImageView *clubOneFlag;
@property (weak, nonatomic) IBOutlet UILabel *clubOneName;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *clubOneScore;
@property (weak, nonatomic) IBOutlet UILabel *clubTwoScore;
@property (nonatomic, weak) NSString* gameID;
@property (nonatomic, weak) NSString* userID;

- (IBAction)decreaseClubOneClicked:(id)sender;
- (IBAction)increaseClubOneClicked:(id)sender;
- (IBAction)increaseClubTwoClicked:(id)sender;
- (IBAction)decreaseClubTwoClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@end

