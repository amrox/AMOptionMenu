//
//  AMOptionPopUpButton.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionPopUpButton.h"
#import "AMOptionPopUpButtonCell.h"


#import "AMOptionMenuDataSource.h"

@implementation AMOptionPopUpButton


+ (Class) cellClass
{
    return [AMOptionPopUpButtonCell class];
}

- (AMOptionMenuDataSource*) dataSource
{
	return [[self cell] dataSource];
}


- (void) setDataSource:(AMOptionMenuDataSource*) dataSource
{
	[[self cell] setDataSource:dataSource];
}

@end
