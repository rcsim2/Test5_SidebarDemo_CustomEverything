/*
     File: SidebarTableCellView.m 
 Abstract: 
    Sample NSTableCellView subclass that adds a button outlet. The implementation does layout in -viewWillDraw.
  
  Version: 1.1 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2011 Apple Inc. All Rights Reserved. 
  
*/

#import "SidebarTableCellView.h"


///////////
//NSOutlineView *g_pSidebarOutlineView = nil;



@implementation SidebarTableCellView

@synthesize button = _button;

- (void)awakeFromNib {
    // We want it to appear "inline"
    [[self.button cell] setBezelStyle:NSInlineBezelStyle];
}

//ARC:
//- (void)dealloc {
//    self.button = nil;
//    [super dealloc];
//}

// The standard rowSizeStyle does some specific layout for us. To customize layout for our button, we first call super and then modify things
- (void)viewWillDraw {
    [super viewWillDraw];
    if (![self.button isHidden]) {
        [self.button sizeToFit];
        
        NSRect textFrame = self.textField.frame;
        NSRect buttonFrame = self.button.frame;
        buttonFrame.origin.x = NSWidth(self.frame) - NSWidth(buttonFrame);
        self.button.frame = buttonFrame;
        textFrame.size.width = NSMinX(buttonFrame) - NSMinX(textFrame);
        self.textField.frame = textFrame;
    }
    
    ////////
    // TEST:
    // Even in a subclass we cannot set font. Sucks. Why?
    // YYyyeeesss!!! Works now. We had a wrong connection.
    // We can now set the font of our custom textfield in IB and also here with:
    //[self.textField2 setFont:[NSFont fontWithName:@"Arial-BoldItalicMT" size:20]];
    
    // But it sucks again: now we need to set the row heighth of NSOutlineView but doing
    // that in IB also has no effect. Must we subclass that too??? Major suck.
    // OKOK: works now, we forgot to set NSTableViewRowSizeStyleCustom
    // And more mysteries: now we have added a custom text field which allows font change
    // the standard text field all of a sudden also allows it... Sucks even more.
    // OKOK: almost there: also added a custom image field which we make a little grayer with
    // a False Color filter.
    // TODO: turn blue selection bar to gray.
    // DONE: by using a custom NSTableRowView.
}


- (void)drawRect:(NSRect)dirtyRect {
    // TEST: gray selection highlight
    // This is a good delegate to change selection blue color into gray when we come
    // from minimized or to foreground but we need access to _sidebarOutlineView
    // Mmm, when using a global pointer we crash...
    // Because there is no row selected??? Probably.
    
    // NONO: setEmphasized is for NSTableRowView
    //[super drawRect:dirtyRect];
    //[self setEmphasized:NO];
    
    ////////////////
    //NSInteger selectedRow = [g_pSidebarOutlineView selectedRow];
    //NSTableRowView *myRowView = [g_pSidebarOutlineView rowViewAtRow:selectedRow makeIfNecessary:NO];
    //[myRowView setEmphasized:NO];
    ////////////////
}



@end
