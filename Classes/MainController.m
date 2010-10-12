    //
//  MainController.m
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import "MainController.h"

#import "PDFRendererView.h"


@implementation MainController


#pragma mark -
#pragma mark View management


- (void) loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.autoresizesSubviews = YES;
	
	PDFRendererView *rendererView = [[[PDFRendererView alloc] initWithFrame:self.view.bounds] autorelease];
	rendererView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	rendererView.pdfPath = [[NSBundle mainBundle] pathForResource:@"ccrf" ofType:@"pdf"];
	
	[self.view addSubview:rendererView];
}


#pragma mark -
#pragma mark Initialization and memory management


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}


- (id) init {
	if ((self = [super init])) {
		[self loadView];
	}
	
	return self;
}


- (void)dealloc {
    [super dealloc];
}


@end
