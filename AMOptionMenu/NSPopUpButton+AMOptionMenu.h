//
//  NSPopUpButton+AMOptionMenu.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AMOptionMenuDataSource;

@interface NSPopUpButton (AMOptionMenu)

- (id)initWithFrame:(NSRect)frameRect optionMenu:(AMOptionMenuDataSource*)optionMenu;

@end
