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
    
    NSMutableArray *components = [NSMutableArray array];
    
    PCPieComponent *component1 = [PCPieComponent pieComponentWithTitle:@"2-0" value:33.0];
    [component1 setColour:[UIColor colorWithRed:0.827 green:0.329 blue:0.0 alpha:1.0]];
    
    PCPieComponent *component2 = [PCPieComponent pieComponentWithTitle:@"1-0" value:28.0];
    [component2 setColour:[UIColor colorWithRed:0.576 green:0.594 blue:0.0 alpha:1.0]];
    
    PCPieComponent *component3 = [PCPieComponent pieComponentWithTitle:@"0-0" value:22.0];
    [component3 setColour:[UIColor colorWithRed:0.511 green:0.119 blue:0.16 alpha:1.0]];
    
    PCPieComponent *component4 = [PCPieComponent pieComponentWithTitle:@"0-1" value:17.0];
    [component4 setColour:[UIColor colorWithRed:0.370 green:0.229 blue:0.081 alpha:1.0]];
    
    [components addObject:component1];
    [components addObject:component2];
    [components addObject:component3];
    [components addObject:component4];
    
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
