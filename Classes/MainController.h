//
//  MainController.h
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFKPageFlipper.h"


@interface MainController : UIViewController <AFKPageFlipperDataSource> {
	CGPDFDocumentRef pdfDocument;
	
	AFKPageFlipper *flipper;
}

@end
