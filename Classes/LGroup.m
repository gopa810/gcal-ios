//
//  LGroup.m
//  GCAL
//
//  Created by Peter Kollath on 8/11/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import "LGroup.h"
#import "LCity.h"

@implementation LGroup

@dynamic cities;
@dynamic subGroupsName;
@dynamic title;
@dynamic subGroups;
@dynamic code;



-(LGroup *)findSubGroupWithCode:(NSString *)inCode
{
	for(LGroup * grp in subGroups)
	{
		if ([grp.code compare:inCode] == NSOrderedSame)
			return grp;
	}
	return nil;
}

//@end

//#if 1
/*
 *
 * You do not need any of these.  
 * These are templates for writing custom functions that override the default CoreData functionality.
 * You should delete all the methods that you do not customize.
 * Optimized versions will be provided dynamically by the framework.
 *
 *
 */


// coalesce these into one @interface LGroup (CoreDataGeneratedPrimitiveAccessors) section

//@implementation LGroup (CoreDataGeneratedAccessors)

- (void)addCitiesObject:(LCity *)value 
{    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"cities" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveCities] addObject:value];
    [self didChangeValueForKey:@"cities" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeCitiesObject:(LCity *)value 
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"cities" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveCities] removeObject:value];
    [self didChangeValueForKey:@"cities" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)addCities:(NSSet *)value 
{    
    [self willChangeValueForKey:@"cities" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveCities] unionSet:value];
    [self didChangeValueForKey:@"cities" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeCities:(NSSet *)value 
{
    [self willChangeValueForKey:@"cities" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveCities] minusSet:value];
    [self didChangeValueForKey:@"cities" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addSubGroupsObject:(LGroup *)value 
{    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"subGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveSubGroups] addObject:value];
    [self didChangeValueForKey:@"subGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeSubGroupsObject:(LGroup *)value 
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"subGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveSubGroups] removeObject:value];
    [self didChangeValueForKey:@"subGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)addSubGroups:(NSSet *)value 
{    
    [self willChangeValueForKey:@"subGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveSubGroups] unionSet:value];
    [self didChangeValueForKey:@"subGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeSubGroups:(NSSet *)value 
{
    [self willChangeValueForKey:@"subGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveSubGroups] minusSet:value];
    [self didChangeValueForKey:@"subGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

//#endif


@end
