//
//  ARNFetchedResultsTableView.h
//  ARNFetchedResultsTableView
//
//  Created by Airin on 10/21/2014.
//  Copyright (c) 2014 Airin. All rights reserved.
//

@import CoreData;

@interface ARNFetchedResultsTableView : UITableView

@property (nonatomic, assign) UITableViewRowAnimation sectionInsertAnimation;
@property (nonatomic, assign) UITableViewRowAnimation sectionDeleteAnimation;
@property (nonatomic, assign) UITableViewRowAnimation cellInsertAnimation;
@property (nonatomic, assign) UITableViewRowAnimation cellDeleteAnimation;
@property (nonatomic, assign) UITableViewRowAnimation cellUpdateAnimation;
@property (nonatomic, assign) UITableViewRowAnimation cellMoveFromAnimation;
@property (nonatomic, assign) UITableViewRowAnimation cellMoveToAnimation;

- (void)performFetchWithContext:(NSManagedObjectContext *)context
                   fetchRequest:(NSFetchRequest *)fetchRequest
             sectionNameKeyPath:(NSString *)keyPath
                     fetchLimit:(int)fetchLimit
                      cacheName:(NSString *)cacheName;

- (void)disConnect;

- (NSArray *)fetchObjects;
- (NSInteger)sectionCount;
- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (NSArray *)objectsForSection:(NSInteger)section;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForEntityInTableView:(NSManagedObject *)entity;

@end
