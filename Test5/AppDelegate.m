//
//  AppDelegate.m
//  Test5
//
//  Created by Rik Goossens on 01/03/2020.
//  Copyright © 2020 Rik Goossens. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


// Fuck it. We do not get notified because we cannot connect to the App's delegate
// in IB. Why why why???? Xcode suck donkey's balls.
- (void)windowDidBecomeKey:(NSNotification *)notification {
    // do something
}


@end
