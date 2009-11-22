//
//  AMOptionPopUpButtonCell.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski  on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMOptionMenuDataSource;

@interface AMOptionPopUpButtonCell : NSPopUpButtonCell
{
	AMOptionMenuDataSource* _optionMenuDataSource;
}


@property (nonatomic, retain) AMOptionMenuDataSource* optionMenuDataSource;


@end
