//
//  AnimateViewHelper.m
//  RelaxAlbum
//
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AnimateViewHelper.h"
@implementation AnimateViewHelper

#pragma mark -
#pragma mark View animation method

+ (void)animateView:(UIView*)sender {
        
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	CATransform3D scale1 = CATransform3DMakeScale(0.2, 0.2, 1);
	CATransform3D scale2 = CATransform3DMakeScale(0.5, 0.5, 1);
	CATransform3D scale3 = CATransform3DMakeScale(0.8, 0.8, 1);
	CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
	
	NSArray *frameValues = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:scale1],
							[NSValue valueWithCATransform3D:scale2],
							[NSValue valueWithCATransform3D:scale3],
							[NSValue valueWithCATransform3D:scale4],
							nil];
	[animation setValues:frameValues];
	
	NSArray *frameTimes = [NSArray arrayWithObjects:
						   [NSNumber numberWithFloat:0.2],
						   [NSNumber numberWithFloat:0.5],
						   [NSNumber numberWithFloat:0.8],
						   [NSNumber numberWithFloat:1.0],
						   nil];
	[animation setKeyTimes:frameTimes];
	
	animation.fillMode = kCAFillModeForwards;
	animation.removedOnCompletion = NO;
	animation.duration =.5;
	[sender.layer addAnimation:animation forKey:@"popup"];
        
}


@end

