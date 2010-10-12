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
#pragma mark Data source implementation


- (NSInteger) numberOfPagesForPageFlipper:(AFKPageFlipper *)pageFlipper {
	return CGPDFDocumentGetNumberOfPages(pdfDocument);
}


- (UIView *) viewForPage:(NSInteger) page inFlipper:(AFKPageFlipper *) pageFlipper {
	PDFRendererView *result = [[[PDFRendererView alloc] initWithFrame:pageFlipper.bounds] autorelease];
	result.pdfDocument = pdfDocument;
	result.pageNumber = page;
	
	return result;
}


#pragma mark -
#pragma mark View management


- (void) loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.autoresizesSubviews = YES;
	
	AFKPageFlipper *flipper = [[[AFKPageFlipper alloc] initWithFrame:self.view.bounds] autorelease];
	flipper.dataSource = self;
	
	[self.view addSubview:flipper];
	
	flipper.currentPage = 2;
}


#pragma mark -
#pragma mark Initialization and memory management


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}


- (id) init {
	if ((self = [super init])) {
		pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef) [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ccrf" ofType:@"pdf"]]);
		
		[self loadView];
	}
	
	return self;
}


- (void)dealloc {
	CGPDFDocumentRelease(pdfDocument);
    [super dealloc];
}


@end
