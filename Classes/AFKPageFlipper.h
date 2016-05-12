//
//  AFKPageFlipper.h
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class AFKPageFlipper;


@protocol AFKPageFlipperDataSource

- (NSInteger) numberOfPagesForPageFlipper:(AFKPageFlipper *) pageFlipper;
- (UIView *) viewForPage:(NSInteger) page inFlipper:(AFKPageFlipper *) pageFlipper;

@end


typedef enum {
	AFKPageFlipperDirectionLeft,
	AFKPageFlipperDirectionRight,
} AFKPageFlipperDirection;



@interface AFKPageFlipper : UIView {
	NSObject <AFKPageFlipperDataSource> *dataSource;
	NSInteger currentPage;
	NSInteger numberOfPages;
	
	UIView *currentView;
	UIView *nextView;
	
	CALayer *backgroundAnimationLayer;
	CALayer *flipAnimationLayer;
	
	AFKPageFlipperDirection flipDirection;
	float startFlipAngle;
	float endFlipAngle;
	float currentAngle;

	BOOL setNextViewOnCompletion;
	BOOL animating;
	
	BOOL disabled;
    CGFloat sensitivityScale;
}

@property (nonatomic,retain) NSObject <AFKPageFlipperDataSource> *dataSource;
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic,assign) BOOL disabled;
@property (nonatomic,assign) CGFloat sensitivityScale;

- (void) setCurrentPage:(NSInteger) value animated:(BOOL) animated;

@end
