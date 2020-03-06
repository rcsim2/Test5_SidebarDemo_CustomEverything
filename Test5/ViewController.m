//
//  ViewController.m
//  Test5
//
//  Created by Rik Goossens on 01/03/2020.
//  Copyright © 2020 Rik Goossens. All rights reserved.
//

#import "ViewController.h"

#import "SidebarTableCellView.h"
#import "SidebarTableRowView.h"




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    ////////////
    //g_pSidebarOutlineView = _sidebarOutlineView;
    
    
    // Connect the fuckers here
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(windowDidResize:) name:nil object: nil];
    [nc addObserver:self selector:@selector(windowDidBecomeKey:) name:nil object: nil];
    [nc addObserver:self selector:@selector(windowDidDeminiaturize:) name:nil object: nil];
    
    
    
    
    
    ////////////////////////
    // The array determines our order
    // ARC:
    //_topLevelItems = [[NSArray arrayWithObjects:@"Favorites", @"Content Views", @"Mailboxes", @"A Fourth Group", nil] retain];
    _topLevelItems = [NSArray arrayWithObjects:@"Favorites", @"Content Views", @"Mailboxes", @"A Fourth Group", nil];

    // The data is stored ina  dictionary. The objects are the nib names to load.
    _childrenDictionary = [NSMutableDictionary new];
    [_childrenDictionary setObject:[NSArray arrayWithObjects:@"ContentView1", @"ContentView2", @"ContentView3", nil] forKey:@"Favorites"];
    [_childrenDictionary setObject:[NSArray arrayWithObjects:@"ContentView1", @"ContentView2", @"ContentView3", nil] forKey:@"Content Views"];
    [_childrenDictionary setObject:[NSArray arrayWithObjects:@"ContentView2", nil] forKey:@"Mailboxes"];
    [_childrenDictionary setObject:[NSArray arrayWithObjects:@"ContentView1", @"ContentView1", @"ContentView1", @"ContentView1", @"ContentView2", nil] forKey:@"A Fourth Group"];
    
    // The basic recipe for a sidebar. Note that the selectionHighlightStyle is set to NSTableViewSelectionHighlightStyleSourceList in the nib
    [_sidebarOutlineView sizeLastColumnToFit];
    [_sidebarOutlineView reloadData];
    [_sidebarOutlineView setFloatsGroupRows:NO];

    // NSTableViewRowSizeStyleDefault should be used, unless the user has picked an explicit size. In that case, it should be stored out and re-used.
    //[_sidebarOutlineView setRowSizeStyle:NSTableViewRowSizeStyleDefault];
    [_sidebarOutlineView setRowSizeStyle:NSTableViewRowSizeStyleCustom];
    
    // Expand all the root items; disable the expansion animation that normally happens
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
        [_sidebarOutlineView expandItem:nil expandChildren:YES];
    [NSAnimationContext endGrouping];
    ////////////////////////
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


// This catches deminiaturize but not did become key window
- (void)viewWillAppear {
    
}



// Why are these not called
// Not connected to delegate???
//
- (void)windowDidResize:(NSNotification *)notification {
    
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    // CRASH: because there is nothing selected
//    //////////////
//    NSInteger selectedRow = [_sidebarOutlineView selectedRow];
//    NSTableRowView *myRowView = [_sidebarOutlineView rowViewAtRow:selectedRow makeIfNecessary:NO];
//    [myRowView setEmphasized:NO];
//    //////////////
}

- (void)windowDidDeminiaturize:(NSNotification *)notification {
    
}







////////////////////
// ARC:
//- (void)dealloc {
//    [_currentContentViewController release];
//    [_topLevelItems release];
//    [_childrenDictionary release];
//    [super dealloc];
//}

- (void)_setContentViewToName:(NSString *)name {
    if (_currentContentViewController) {
        [[_currentContentViewController view] removeFromSuperview];
        // ARC:
        //[_currentContentViewController release];
    }
    _currentContentViewController = [[NSViewController alloc] initWithNibName:name bundle:nil]; // Retained
    NSView *view = [_currentContentViewController view];
    view.frame = _mainContentView.bounds;
    [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [_mainContentView addSubview:view];
}



- (void)outlineViewSelectionIsChanging:(NSNotification *)notification {
    // TEST: gray selection highlight
    // See: https://stackoverflow.com/questions/9463871/change-selection-color-on-view-based-nstableview
    // When setEmphasized is set to YES you get the blue highlight, when NO you get the gray highlight.
    // NOTE: but when window gets to the forground, selection will be blue again.
    // Also when arrowing to items.
    // Also when coming from minimized.
    // Better try to get any highlight color we like.
    // NOTE: not needed anymore: we use our custom SidebarTableRowView
    ////////////////
    //NSInteger selectedRow = [_sidebarOutlineView selectedRow];
    //NSTableRowView *myRowView = [_sidebarOutlineView rowViewAtRow:selectedRow makeIfNecessary:NO];
    //[myRowView setEmphasized:NO];
    ////////////////
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    // TEST: gray selection highlight
    // NOTE: not needed anymore: we use our custom SidebarTableRowView
    ////////////////
    //NSInteger selectedRow = [_sidebarOutlineView selectedRow];
    //NSTableRowView *myRowView = [_sidebarOutlineView rowViewAtRow:selectedRow makeIfNecessary:NO];
    //[myRowView setEmphasized:NO];
    ////////////////
    if ([_sidebarOutlineView selectedRow] != -1) {
        NSString *item = [_sidebarOutlineView itemAtRow:[_sidebarOutlineView selectedRow]];
        if ([_sidebarOutlineView parentForItem:item] != nil) {
            // Only change things for non-root items (root items can be selected, but are ignored)
            [self _setContentViewToName:item];
        }
    }
}



- (NSArray *)_childrenForItem:(id)item {
    NSArray *children;
    if (item == nil) {
        children = _topLevelItems;
    } else {
        children = [_childrenDictionary objectForKey:item];
    }
    return children;
}



// TEST: gray selection highlight
// TODO: subclass NSTableRowView and return it here
// See: https://stackoverflow.com/questions/9463871/change-selection-color-on-view-based-nstableview/39794881
// DONE: Works! We now also keep the gray selection when deminiaturized or becoming key window
// Also, we no longer need the code in outlineViewSelectionDidChange and outlineViewSelectionIsChanging
// (which wasn't working correctly in the first place: it gave the "dancing colors").
// Lesson learned: with Cocoa, when in doubt, subclass everything. This API is so deficient: you need
// to do everything by yourself. Instead of it simply being an option in IB.
// However, got to admit that Non-Client programming (i.e. adjusting standard API behaviour) in Win32 in C
// also was very tricky, often involving subclassing.
// Now, for extra marks: try to get any highlight color we like...
- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item {
    //NSTableRowView *row = [[NSTableRowView alloc] init];
    SidebarTableRowView *row = [[SidebarTableRowView alloc] init];
    [row setIdentifier:@"row"];
    return row;
}



// Method#2
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return [[self _childrenForItem:item] objectAtIndex:index];
}

// Method#3
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if ([outlineView parentForItem:item] == nil) {
        return YES;
    } else {
        return NO;
    }
}

// See: http://www.cocoasteam.com/?p=41
// Method#1: Entry point
- (NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return [[self _childrenForItem:item] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    return [_topLevelItems containsObject:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
    // As an example, hide the "outline disclosure button" for FAVORITES. This hides the "Show/Hide" button and disables the tracking area for that row.
    if ([item isEqualToString:@"Favorites"]) {
        return YES;//NO;
    } else {
        return YES;
    }
}

// Method#4
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    // For the groups, we just return a regular text view.
    if ([_topLevelItems containsObject:item]) {
        NSTextField *result = [outlineView makeViewWithIdentifier:@"HeaderTextField" owner:self];
        // Uppercase the string value, but don't set anything else. NSOutlineView automatically applies attributes as necessary
        NSString *value = [item uppercaseString];
        [result setStringValue:value];
        return result;
    } else  {
        // The cell is setup in IB. The textField and imageView outlets are properly setup.
        // Special attributes are automatically applied by NSTableView/NSOutlineView for the source list
        SidebarTableCellView *result = [outlineView makeViewWithIdentifier:@"MainCell" owner:self];
        
        result.textField.stringValue = item;
        result.textField2.stringValue = item; // set our custom text field
        
        // Setup the icon based on our section
        id parent = [outlineView parentForItem:item];
        NSInteger index = [_topLevelItems indexOfObject:parent];
        NSInteger iconOffset = index % 4;
        switch (iconOffset) {
            case 0: {
                result.imageView.image = [NSImage imageNamed:NSImageNameIconViewTemplate];
                break;
            }
            case 1: {
                result.imageView.image = [NSImage imageNamed:NSImageNameHomeTemplate];
                break;
            }
            case 2: {
                result.imageView.image = [NSImage imageNamed:NSImageNameQuickLookTemplate];
                break;
            }
            case 3: {
                result.imageView.image = [NSImage imageNamed:NSImageNameSlideshowTemplate];
                break;
            }
        }
        // TEST: set our custom image view
        result.imageView2.image = [NSImage imageNamed:NSImageNameUserGroup];
        
        BOOL hideUnreadIndicator = YES;
        // Setup the unread indicator to show in some cases. Layout is done in SidebarTableCellView's viewWillDraw
        if (index == 0) {
            // First row in the index
            hideUnreadIndicator = NO;
            [result.button setTitle:@"42"];
            [result.button sizeToFit];
            // Make it appear as a normal label and not a button
            [[result.button cell] setHighlightsBy:0];
        } else if (index == 2) {
            // Example for a button
            hideUnreadIndicator = NO;
            result.button.target = self;
            result.button.action = @selector(buttonClicked:);
            [result.button setImage:[NSImage imageNamed:NSImageNameAddTemplate]];
            // Make it appear as a button
            [[result.button cell] setHighlightsBy:NSPushInCellMask|NSChangeBackgroundCellMask];
        }
        [result.button setHidden:hideUnreadIndicator];
        return result;
    }
}







- (void)buttonClicked:(id)sender {
    // Example target action for the button
    NSInteger row = [_sidebarOutlineView rowForView:sender];
    NSLog(@"row: %ld", row);
}

- (IBAction)sidebarMenuDidChange:(id)sender {
    // Allow the user to pick a sidebar style
    NSInteger rowSizeStyle = [sender tag];
    [_sidebarOutlineView setRowSizeStyle:rowSizeStyle];
}

- (void)menuNeedsUpdate:(NSMenu *)menu {
    for (NSInteger i = 0; i < [menu numberOfItems]; i++) {
        NSMenuItem *item = [menu itemAtIndex:i];
        if (![item isSeparatorItem]) {
            // In IB, the tag was set to the appropriate rowSizeStyle. Read in that value.
            NSInteger state = ([item tag] == [_sidebarOutlineView rowSizeStyle]) ? 1 : 0;
            [item setState:state];
        }
    }
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    return NO;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (proposedMinimumPosition < 75) {
        proposedMinimumPosition = 75;
    }
    return proposedMinimumPosition;
}
///////////////////


@end
