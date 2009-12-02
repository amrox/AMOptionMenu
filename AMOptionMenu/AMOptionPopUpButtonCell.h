//
//  AMOptionPopUpButtonCell.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski  on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMOptionMenuController;

@interface AMOptionPopUpButtonCell : NSPopUpButtonCell
{
	AMOptionMenuController* _optionMenuController;
}


@property (nonatomic, retain) AMOptionMenuController* optionMenuController;


@end
