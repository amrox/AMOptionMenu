//
//  AMOptionPopUpButtonCell.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski  on 7/10/09.
//  Copyright 2009 The Neat Company. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMOptionMenuDataSource;

@interface AMOptionPopUpButtonCell : NSPopUpButtonCell
{
	AMOptionMenuDataSource* _dataSource;
}


@property (nonatomic, retain) AMOptionMenuDataSource* dataSource;


@end
