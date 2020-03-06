//
//  ViewController.h
//  Test5
//
//  Created by Rik Goossens on 01/03/2020.
//  Copyright © 2020 Rik Goossens. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSApplicationDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource, NSMenuDelegate, NSWindowDelegate> {
@private
    NSWindow *_window;
    IBOutlet NSView *_mainContentView;
    NSArray *_topLevelItems;
    NSViewController *_currentContentViewController;
    NSMutableDictionary *_childrenDictionary;
    IBOutlet NSOutlineView *_sidebarOutlineView;
    
}


- (void)windowDidResize:(NSNotification *)notification;
- (void)windowDidBecomeKey:(NSNotification *)notification;
- (void)windowDidDeminiaturize:(NSNotification *)notification;


// Based on Apple SidebarDemo
// 0. We can keep ARC on by just commenting out the non-ARC compatible code and using
// arrayWithObjects without retain
// 1. Connect NSOutlineView in Storyboard with IBOutlet _sidebarOutlineView
// 2. In The Connections Inspectors we have to connect dataSource, delegate and
// Referencing Outlet with the View Controller (last one will be done by 1.)
// 3. Set the Main Cell class to Custom Class: SidebarTableCellView
// 4. In the Identity Inspector set the Item Table Cell View Identifier to: MainCell and that
// of the Header to: HeaderCell
// 5. We got no headers because they were in a Cell whereas they were on their own in the sample

// NOTE: We use the Legacy Build System. This way we get the Debug/Release .apps in
// our project folder and keep the output relatively small.
// Note that the Release output also creates a .dSYM file with debug symbols. The Debug output has
// that file in /Users/rg/Library/Developer/Xcode/DerivedData

// SUCK: In IB we tried to change the Highlight property of the Sidebar Outline View just to test.
// This totally fucks up the item height and reverts it to normal small bars. Even Cmd-Z to
// the original Storyboard keeps the small bars. We cloned from GitHub to get the original back.
// Xcode sucks.


@end

