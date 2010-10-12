//
//  PDFRendererView.m
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import "PDFRendererView.h"


@implementation PDFRendererView


#pragma mark -
#pragma mark Property management

@synthesize pdfPath;


- (void) setPdfPath:(NSString *) value {
	if (pdfPath) {
		[pdfPath release];
	}
	
	if (pdfDocument) {
		CGPDFDocumentRelease(pdfDocument);
	}
	
	pdfPath = [value retain];
	pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef) [NSURL fileURLWithPath:pdfPath]);
	
	NSAssert1(pdfDocument, @"Unable to load PDF document %@!", value);
	
	pageNumber = 1;
	[self setNeedsDisplay];
}


@synthesize pageNumber;


- (void) setPageNumber:(int) value {
	pageNumber = value;
	
	[self setNeedsDisplay];
}


#pragma mark -
#pragma mark Drawing


- (void) setFrame:(CGRect) value {
	[super setFrame:value];
	
	[self setNeedsDisplay];
}


- (void) drawPDFPage:(CGPDFPageRef) pdfPage inRect:(CGRect) rect usingContext:(CGContextRef) context {
	CGContextSaveGState(context);
	
	// Draw PDF
	
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGRect boundingBox = CGPDFPageGetBoxRect(pdfPage, kCGPDFCropBox);
	
	float ratio = MIN(rect.size.width / boundingBox.size.width, rect.size.height / boundingBox.size.height);
	
	CGAffineTransform pdfTransform = CGAffineTransformMakeTranslation(rect.origin.x + (rect.size.width - boundingBox.size.width * ratio) / 2, rect.origin.y + (rect.size.height - boundingBox.size.height * ratio) / 2);
	pdfTransform = CGAffineTransformScale(pdfTransform, ratio, ratio);
	
	CGContextConcatCTM(context, pdfTransform);
	CGContextDrawPDFPage(context, pdfPage);
	CGContextRestoreGState(context);
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Clear background
	
	CGContextSaveGState(context);
	
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextFillRect(context, self.bounds);
	
	CGContextRestoreGState(context);
	
	// Load PDF page

	if (self.bounds.size.width > self.bounds.size.height) {
		
		// If the width of the view's bounds is greater than the height,
		// we display two pages side-by-side
		
		CGRect rect = self.bounds;
		rect.size.width /= 2;
		
		[self drawPDFPage:CGPDFDocumentGetPage(pdfDocument, (pageNumber - 1) * 2) inRect:rect usingContext:context];
		
		rect.origin.x = rect.size.width;
		
		[self drawPDFPage:CGPDFDocumentGetPage(pdfDocument, (pageNumber - 1) * 2 + 1) inRect:rect usingContext:context];
	} else {
		[self drawPDFPage:CGPDFDocumentGetPage(pdfDocument, pageNumber) inRect:self.bounds usingContext:context];
	}
}


#pragma mark -
#pragma mark Initialization and memory management


- (void)dealloc {
    [super dealloc];
}


@end
