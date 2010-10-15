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
	return self.view.bounds.size.width > self.view.bounds.size.height ? ceil((float) CGPDFDocumentGetNumberOfPages(pdfDocument) / 2) : CGPDFDocumentGetNumberOfPages(pdfDocument);
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
	[super loadView];
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	flipper = [[[AFKPageFlipper alloc] initWithFrame:self.view.bounds] autorelease];
	flipper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	flipper.dataSource = self;
	
	[self.view addSubview:flipper];
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
