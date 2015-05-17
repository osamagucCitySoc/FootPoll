//
//  PollResultView.h
//  FootPoll
//
//  Created by Osama Rabie on 5/13/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PollResultView : UIView


@property (nonatomic, strong) NSArray* votes;
- (id)initWithNib;
-(void)initUI;

@end
