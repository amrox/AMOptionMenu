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
	AMOptionMenuDataSource* _dataSource;
	//NSMenuItem* _titleItem;
}


@property (nonatomic, retain) AMOptionMenuDataSource* dataSource;


@end
