//
//  AFKPageFlipper.m
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-12.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import "AFKPageFlipper.h"


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


- (void) initFlip {
	
	// Create screenshots of view
	
	UIImage *currentImage = [self.currentView imageByRenderingView];
	UIImage *newImage = [self.newView imageByRenderingView];
	
	// Hide existing views
	
	self.currentView.alpha = 0;
	self.newView.alpha = 0;
	
	// Create representational layers
	
	CGRect rect = self.bounds;
	rect.size.width /= 2;
	
	backgroundAnimationLayer = [CALayer layer];
	backgroundAnimationLayer.frame = self.bounds;
	backgroundAnimationLayer.zPosition = -300000;
	
	CALayer *leftLayer = [CALayer layer];
	leftLayer.frame = rect;
	leftLayer.masksToBounds = YES;
	leftLayer.contentsGravity = kCAGravityLeft;
	
	[backgroundAnimationLayer addSublayer:leftLayer];
	
	rect.origin.x = rect.size.width;
	
	CALayer *rightLayer = [CALayer layer];
	rightLayer.frame = rect;
	rightLayer.masksToBounds = YES;
	rightLayer.contentsGravity = kCAGravityRight;
	
	[backgroundAnimationLayer addSublayer:rightLayer];
	
	if (flipDirection == AFKPageFlipperDirectionRight) {
		leftLayer.contents = (id) [newImage CGImage];
		rightLayer.contents = (id) [currentImage CGImage];
	} else {
		leftLayer.contents = (id) [currentImage CGImage];
		rightLayer.contents = (id) [newImage CGImage];
	}

	[self.layer addSublayer:backgroundAnimationLayer];
	
	rect.origin.x = 0;
	
	flipAnimationLayer = [CATransformLayer layer];
	flipAnimationLayer.anchorPoint = CGPointMake(1.0, 0.5);
	flipAnimationLayer.frame = rect;
	
	[self.layer addSublayer:flipAnimationLayer];
	
	CALayer *backLayer = [CALayer layer];
	backLayer.frame = flipAnimationLayer.bounds;
	backLayer.doubleSided = NO;
	backLayer.masksToBounds = YES;
	
	[flipAnimationLayer addSublayer:backLayer];
	
	CALayer *frontLayer = [CALayer layer];
	frontLayer.frame = flipAnimationLayer.bounds;
	frontLayer.doubleSided = NO;
	frontLayer.masksToBounds = YES;
	frontLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
	
	[flipAnimationLayer addSublayer:frontLayer];
	
	if (flipDirection == AFKPageFlipperDirectionRight) {
		backLayer.contents = (id) [currentImage CGImage];
		backLayer.contentsGravity = kCAGravityLeft;
		
		frontLayer.contents = (id) [newImage CGImage];
		frontLayer.contentsGravity = kCAGravityRight;
		
		CATransform3D transform = CATransform3DIdentity;
		transform.m34 = 1.0f / 2500.0f;
		transform = CATransform3DRotate(transform, -M_PI, 0.0, 1.0, 0.0);
		
		flipAnimationLayer.transform = transform;
		
		startFlipAngle = 0;
		startFlipAngle = -M_PI;
	} else {
		backLayer.contentsGravity = kCAGravityLeft;
		backLayer.contents = (id) [newImage CGImage];
		
		frontLayer.contents = (id) [currentImage CGImage];
		frontLayer.contentsGravity = kCAGravityRight;
		
		CATransform3D transform = CATransform3DIdentity;
		transform.m34 = 1.0f / 2500.0f;
		transform = CATransform3DRotate(transform, 0, 0.0, 1.0, 0.0);
		
		flipAnimationLayer.transform = transform;
		
		startFlipAngle = -M_PI;
		endFlipAngle = 0;
	}

	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	
	animation.duration = 1.0;
	animation.fromValue = [NSNumber numberWithFloat:startFlipAngle];
	animation.toValue = [NSNumber numberWithFloat:endFlipAngle];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.delegate = self;
	
	[flipAnimationLayer addAnimation:animation forKey:Nil];
}


- (void) cleanupFlipAndShowNewView:(BOOL) setNewView {
	[backgroundAnimationLayer removeFromSuperlayer];
	[flipAnimationLayer removeFromSuperlayer];
	
	backgroundAnimationLayer = Nil;
	flipAnimationLayer = Nil;
	
	if (setNewView) {
		[self.currentView removeFromSuperview];
		self.currentView = Nil;
		
		self.newView.alpha = 1;
	} else {
		[self.newView removeFromSuperview];
		self.newView = Nil;
	}

}

#pragma mark -
#pragma mark Animation management


- (void)animationDidStop:(CAAnimation *) theAnimation finished:(BOOL) flag {
	[self cleanupFlipAndShowNewView:flag];
}


- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
	[self cleanupFlipAndShowNewView:[finished boolValue]];
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


- (BOOL) doSetCurrentPage:(NSInteger) value {
	if (value == currentPage) {
		return FALSE;
	}
	
	flipDirection = (value < currentPage ? AFKPageFlipperDirectionRight : AFKPageFlipperDirectionLeft);
	currentPage = value;
	
	self.newView = [self.dataSource viewForPage:value inFlipper:self];
	
	return TRUE;
}	

- (void) setCurrentPage:(NSInteger) value {
	if (![self doSetCurrentPage:value]) {
		return;
	}
	
	self.newView.alpha = 0;
	
	[UIView beginAnimations:@"" context:Nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	self.newView.alpha = 1;
	
	[UIView commitAnimations];
} 


@synthesize dataSource;


- (void) setDataSource:(NSObject <AFKPageFlipperDataSource>*) value {
	if (dataSource) {
		[dataSource release];
	}
	
	dataSource = [value retain];
	self.currentPage = 1;
}


#pragma mark -
#pragma mark Initialization and memory management


+ (Class) layerClass {
	return [CATransformLayer class];
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
