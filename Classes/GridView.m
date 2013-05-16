//
//  GridView.m
//  AFKPageFlipper
//
//  Created by veryeast on 13-5-15.
//
//

#import "GridView.h"

@implementation GridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (GridView *)gridView
{
    NSUInteger index = iPhone5 ? 0 : 1;
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GridView" owner:self options:nil];
    return nibs[index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
