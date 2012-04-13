//
//  RBAppDelegate.h
//  Min Radio
//
//  Created by Rune Botten on 04.04.12.
//  Copyright (c) 2012 Rune Botten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@interface RBAppDelegate : NSObject <NSApplicationDelegate>
{
    NSStatusItem *systemStatusItem;
    QTMovie *radio;
    
    NSMutableArray *menuItems;
    NSArray *stations;
}

@end
