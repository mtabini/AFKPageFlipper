//
//  PDFRendererView.h
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PDFRendererView : UIView {
	CGPDFDocumentRef pdfDocument;
	
	int pageNumber;
}


@property (nonatomic,assign) CGPDFDocumentRef pdfDocument;

@property (nonatomic,assign) int pageNumber;


@end
