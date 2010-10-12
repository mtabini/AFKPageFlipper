//
//  PDFRendererView.h
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PDFRendererView : UIView {
	NSString *pdfPath;
	CGPDFDocumentRef pdfDocument;
	
	int pageNumber;
}


@property (nonatomic,retain) NSString *pdfPath;

@property (nonatomic,assign) int pageNumber;


@end
