//
//  ARNFetchedResultsTableView.m
//  ARNFetchedResultsTableView
//
//  Created by Airin on 10/21/2014.
//  Copyright (c) 2014 Airin. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ARNFetchedResultsTableView.h"

#import <ARNFetchedResultsController.h>

@interface ARNFetchedResultsTableView ()

@property (nonatomic, strong) ARNFetchedResultsController *fetchedResultsController;

@end

@implementation ARNFetchedResultsTableView

- (void)dealloc
{
    [self disConnect];
}

- (void)disConnect
{
    [_fetchedResultsController disConnect];
}

- (void)commonInit
{
    self.fetchedResultsController = [[ARNFetchedResultsController alloc] init];
    
    self.sectionInsertAnimation = UITableViewRowAnimationAutomatic;
    self.sectionDeleteAnimation = UITableViewRowAnimationAutomatic;
    self.cellInsertAnimation = UITableViewRowAnimationAutomatic;
    self.cellDeleteAnimation = UITableViewRowAnimationAutomatic;
    self.cellUpdateAnimation = UITableViewRowAnimationAutomatic;
    self.cellMoveFromAnimation = UITableViewRowAnimationAutomatic;
    self.cellMoveToAnimation = UITableViewRowAnimationAutomatic;
    
    __weak typeof(self) weakSelf = self;
    
    self.fetchedResultsController.willChangeContentBlock = ^(NSFetchedResultsController *frController) {
        if (!weakSelf) { return; }
        [weakSelf beginUpdates];
    };
    
    self.fetchedResultsController.didChangeSectionBlock = ^(id <NSFetchedResultsSectionInfo> sectionInfo, NSFetchedResultsChangeType type, NSUInteger sectionIndex){
        if (!weakSelf) { return; }
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [weakSelf insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:weakSelf.sectionInsertAnimation];
                break;
            case NSFetchedResultsChangeDelete:
                [weakSelf deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:weakSelf.sectionDeleteAnimation];
                break;
            default:
                break;
        }
    };
    
    self.fetchedResultsController.didChangeObjectBlock = ^(id anObject, NSFetchedResultsChangeType type, NSIndexPath *indexPath, NSIndexPath *newIndexPath) {
        if (!weakSelf) { return; }
        
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [weakSelf insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:weakSelf.cellInsertAnimation];
                break;
                
            case NSFetchedResultsChangeDelete:
                [weakSelf deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:weakSelf.cellDeleteAnimation];
                break;
                
            case NSFetchedResultsChangeUpdate: {
                if (!newIndexPath) {
                    [weakSelf reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:weakSelf.cellUpdateAnimation];
                }
                else {
                    [weakSelf deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:weakSelf.cellDeleteAnimation];
                    [weakSelf insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:weakSelf.cellInsertAnimation];
                }
                break;
            }
                
            case NSFetchedResultsChangeMove:
                [weakSelf deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:weakSelf.cellDeleteAnimation];
                [weakSelf insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:weakSelf.cellInsertAnimation];
                break;
        }
    };
    
    self.fetchedResultsController.didChangeContentBlock = ^(NSFetchedResultsController *frController){
        if (!weakSelf) { return; }
        [weakSelf endUpdates];
    };
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (!(self = [super initWithFrame:frame style:style])) { return nil; }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) { return nil; }
    
    [self commonInit];
    
    return self;
}

- (void)performFetchWithContext:(NSManagedObjectContext *)context
                   fetchRequest:(NSFetchRequest *)fetchRequest
             sectionNameKeyPath:(NSString *)keyPath
                     fetchLimit:(int)fetchLimit
                      cacheName:(NSString *)cacheName
{
    [self.fetchedResultsController performFetchWithContext:context
                                              fetchRequest:fetchRequest
                                        sectionNameKeyPath:keyPath
                                                fetchLimit:fetchLimit
                                                 cacheName:cacheName];
}

- (NSArray *)fetchObjects
{
    return [self.fetchedResultsController fetchObjects];
}

- (NSInteger)sectionCount
{
    return [self.fetchedResultsController sectionCount];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    return [self.fetchedResultsController titleForHeaderInSection:section];
}

- (NSArray *)objectsForSection:(NSInteger)section
{
    return [self.fetchedResultsController objectsForSection:section];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController numberOfRowsInSection:section];
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectForIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForEntityInTableView:(NSManagedObject *)entity
{
    return [self.fetchedResultsController indexPathForEntityInTableView:entity];
}


@end
