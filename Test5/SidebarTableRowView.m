// Custom NSTableRowView to get a gray highlight color instead of standard blue

#import "SidebarTableRowView.h"


@implementation SidebarTableRowView


//- (void)awakeFromNib {
//}
//
//- (void)viewWillDraw {
//    [super viewWillDraw];
//    
//}


- (void)drawRect:(NSRect)dirtyRect {
    // This is a good delegate to change selection blue color into gray
    [super drawRect:dirtyRect];
    [self setEmphasized:NO];
}



@end
