//
//  MCFadeSegue.m
//  FootPoll
//
//  Created by Osama Rabie on 5/10/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MCFadeSegue.h"


@implementation MCFadeSegue


- (void)perform
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.type = kCATransitionFade;
    
    [[[[[self sourceViewController] view] window] layer] addAnimation:transition
                                                               forKey:kCATransitionFade];
    
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
//     presentViewController:[self destinationViewController]
  //   animated:NO completion:NULL];
}

@end
