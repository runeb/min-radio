//
//  RBAppDelegate.m
//  Min Radio
//
//  Created by Rune Botten on 04.04.12.
//  Copyright (c) 2012 Rune Botten. All rights reserved.
//

#import "RBAppDelegate.h"
#import <QTKit/QTKit.h>

@implementation RBAppDelegate

-(void) play:(NSMenuItem*) menuItem
{
    for(NSMenuItem *i in menuItems) {
        [i setState:NSOffState];
    }
    [menuItem setState:NSOnState];
    
    NSDictionary *station = [stations objectAtIndex:menuItem.tag];
    NSString *name = [station valueForKey:@"name"];
    [systemStatusItem setTitle:name];
    
    NSLog(@"Spiller %@ fra %@", name, [station valueForKey:@"url"]);
    [self playURLString:[station valueForKey:@"url"]];
}

- (void) createMenu
{
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    systemStatusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [systemStatusItem setTitle:@"Radio"];
    [systemStatusItem setHighlightMode:YES];
    [systemStatusItem retain];
    
    NSMenu *appMenu = [[NSMenu alloc] init];
    
    NSString *stationsPath = [[NSBundle mainBundle]
                              pathForResource:@"stations"
                              ofType:@"plist"];

    stations = [NSArray arrayWithContentsOfFile:stationsPath];
    [stations retain];
    
    for(NSDictionary *station in stations) {
        NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:[station valueForKey:@"name"]
                                                    action:@selector(play:) 
                                             keyEquivalent:@""];
        [mi setTag:[menuItems count]];
        [menuItems addObject:mi];
        [appMenu addItem:mi];
        [mi release];
    }
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    [appMenu addItemWithTitle:@"Avslutt" action:@selector(quit) keyEquivalent:@""];
    [systemStatusItem setMenu:appMenu];
    [appMenu release];
}

-(void) playURLString:(NSString*) urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *movieAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
								url,
                                QTMovieURLAttribute,
								[NSNumber numberWithBool:YES],
                                QTMovieOpenForPlaybackAttribute,
								nil];
    
    if(radio) {
        [radio stop];
        [radio release];
    }

    radio = [[QTMovie alloc] initWithAttributes:movieAttrs error:nil];
    [radio autoplay];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    menuItems = [[NSMutableArray alloc] init];
    [self createMenu];    
}

- (void) applicationWillTerminate:(NSNotification *)notification
{
    [menuItems release];
    [stations release];
    if(radio) {
        [radio stop];
        [radio release];
    }
}

- (void) quit {    
    [NSApp terminate:NULL];
}

@end
