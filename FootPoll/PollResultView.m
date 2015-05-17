//
//  PollResultView.m
//  FootPoll
//
//  Created by Osama Rabie on 5/13/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "PollResultView.h"
#import "PCPieChart.h"

@implementation PollResultView

- (id)initWithNib
{
    // where MyCustomView is the name of your nib
    UINib *nib = [UINib nibWithNibName:@"PollResultView" bundle:[NSBundle mainBundle]];
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
    int height = 160;
    int width = [self bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self bounds].size.width-width)/2,0,width,height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:height-20];
    [pieChart setSameColorLabel:YES];
    pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    pieChart.percentageFont = [UIFont fontWithName:@"DroidArabicKufi-bold" size:15];
    

    [self addSubview:pieChart];
    
    int totalVotes = 0;
    
    for(NSDictionary* vote in self.votes)
    {
        totalVotes += [[vote objectForKey:@"totalScores"] intValue];
    }
    
    
    NSMutableArray *components = [NSMutableArray array];
    
    for(int i = 0 ; i < self.votes.count ; i++)
    {
        NSDictionary* vote = [self.votes objectAtIndex:i];
        
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[vote objectForKey:@"score"] value:[[vote objectForKey:@"totalScores"] floatValue]];
        if(i == 0)
        {
            [component setColour:[UIColor colorWithRed:0.827 green:0.329 blue:0.0 alpha:1.0]];
        }else if(i == 1)
        {
            [component setColour:[UIColor colorWithRed:0.576 green:0.594 blue:0.0 alpha:1.0]];
        }else if(i == 2)
        {
            [component setColour:[UIColor colorWithRed:0.511 green:0.119 blue:0.16 alpha:1.0]];
        }else if(i == 3)
        {
            [component setColour:[UIColor colorWithRed:0.370 green:0.229 blue:0.081 alpha:1.0]];
        }
        
        [components addObject:component];
    }

    
    [pieChart setComponents:components];
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


@end
