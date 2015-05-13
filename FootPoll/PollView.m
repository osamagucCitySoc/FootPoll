//
//  PollView.m
//  FootPoll
//
//  Created by Osama Rabie on 5/13/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "PollView.h"

@implementation PollView

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

@end
