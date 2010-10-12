//
//  AFKPageFlipper.m
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-12.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import "AFKPageFlipper.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark -
#pragma mark UIView helpers


@interface UIView(Extended) 

- (UIImage *) imageByRenderingView;

@end


@implementation UIView(Extended)


- (UIImage *) imageByRenderingView {
	
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultingImage;
}

@end


#pragma mark -
#pragma mark Private interface


@interface AFKPageFlipper()

@property (nonatomic,assign) UIView *currentView;
@property (nonatomic,assign) UIView *newView;

@end


@implementation AFKPageFlipper


#pragma mark -
#pragma mark Flip functionality


- (void) startFlip {
	
	// Create screenshots of view
	
	UIImage *currentImage = [self.currentView imageByRenderingView];
	UIImage *newImage = [self.newView imageByRenderingView];
	
	// Hide existing views
	
	self.currentView.alpha = 0;
	self.newView.alpha = 0;
	
	// Create representational layers
	
	CGRect rect = self.bounds;
	rect.size.width /= 2;
	
	CATransform3D transform;
	
	currentLeftLayer = [CALayer layer];
	
	currentLeftLayer.frame = rect;
	currentLeftLayer.contents = (id) [currentImage CGImage];
	currentLeftLayer.masksToBounds = YES;
	currentLeftLayer.contentsGravity = kCAGravityLeft;
	
	[self.layer addSublayer:currentLeftLayer];
	
	newLeftLayer = [CALayer layer];
	
	newLeftLayer.anchorPoint = CGPointMake(1.0, 0.5);
	newLeftLayer.frame = rect;
	newLeftLayer.contents = (id) [newImage CGImage];
	newLeftLayer.masksToBounds = YES;
	newLeftLayer.contentsGravity = kCAGravityLeft;
	
	transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
	transform.m34 = -1.0f / 1500.0f;
	
	newLeftLayer.transform = transform;
	
	[self.layer addSublayer:newLeftLayer];
	
	rect.origin.x = rect.size.width;
	
	newRightLayer = [CALayer layer];
	
	newRightLayer.frame = rect;
	newRightLayer.contents = (id) [newImage CGImage];
	newRightLayer.masksToBounds = YES;
	newRightLayer.contentsGravity = kCAGravityRight;
	
	[self.layer addSublayer:newRightLayer];
	
	currentRightLayer = [CALayer layer];
	
	currentRightLayer.anchorPoint = CGPointMake(0.0, 0.5);
	currentRightLayer.frame = rect;
	currentRightLayer.contents = (id) [currentImage CGImage];
	currentRightLayer.masksToBounds = YES;
	currentRightLayer.contentsGravity = kCAGravityRight;

	transform = CATransform3DIdentity;
	transform.m34 = -1.0f / 1500.0f;
	transform = CATransform3DRotate(transform, -M_PI / 2, 0.0, 1.0, 0.0);
	
	currentRightLayer.transform = transform;
	
	[self.layer addSublayer:currentRightLayer];
	
	// Perform rotations
	
	float kAnimationDuration = 0.5;
	
	CAKeyframeAnimation *newAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.y"];
	
	newAnimation.duration = kAnimationDuration;
	newAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI / 2],
													[NSNumber numberWithFloat:M_PI / 2],
													[NSNumber numberWithFloat:0.0f],
													Nil];
	
	[newLeftLayer addAnimation:newAnimation forKey:Nil];
	
	CABasicAnimation *currentAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	
	currentAnimation.duration = kAnimationDuration / 2;
	currentAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	currentAnimation.toValue = [NSNumber numberWithFloat:-M_PI / 2];
	
	[currentRightLayer addAnimation:currentAnimation forKey:Nil];
}


#pragma mark -
#pragma mark Properties

@synthesize currentView;


- (void) setCurrentView:(UIView *) value {
	if (currentView) {
		[currentView removeFromSuperview];
	}
	
	[self addSubview:value];
	currentView = value;
}


@synthesize newView;


- (void) setNewView:(UIView *) value {
	if (newView) {
		[newView removeFromSuperview];
	}
	
	[self addSubview:value];
	newView = value;
}


@synthesize currentPage;


- (void) setCurrentPage:(NSInteger) value {
	currentPage = value;
	
	self.newView = [self.dataSource viewForPage:value inFlipper:self];
	[self startFlip];
}


@synthesize dataSource;


- (void) setDataSource:(NSObject <AFKPageFlipperDataSource>*) value {
	if (dataSource) {
		[dataSource release];
	}
	
	dataSource = [value retain];
	currentPage = 1;
	self.currentView = [self.dataSource viewForPage:1 inFlipper:self];
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


@end
