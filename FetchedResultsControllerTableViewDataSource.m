//
// Created by Chris Eidhof
//


#import <CoreData/CoreData.h>
#import "FetchedResultsControllerTableViewDataSource.h"

static BOOL const kTableViewEditingEnabled = NO;

@interface FetchedResultsControllerTableViewDataSource ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation FetchedResultsControllerTableViewDataSource

#pragma mark - Instance Methods

- (id)initWithTableView:(UITableView*)tableView
{
    self = [super init];
    if (self) {
        
        self.tableView = tableView;
        self.tableView.dataSource = self;
        
        self.editingEnabled = kTableViewEditingEnabled;
        
    }
    return self;
}

- (id)initWithTableView:(UITableView*)tableView
            objectClass:(Class)objectClass
                context:(NSManagedObjectContext *)context
              predicate:(NSPredicate *)predicate
                sorting:(NSString *)sorting
              ascending:(BOOL)ascending{
    
    self = [super init];
    if(self){
        
        self.tableView = tableView;
        self.tableView.dataSource = self;
        
        self.editingEnabled = kTableViewEditingEnabled;
        
        if(!context){
            return nil;
        }
        
//        if(!context){
//            context = [NSManagedObjectContext MR_defaultContext];
//        }
        
//        NSFetchRequest *request = [objectClass MR_requestAllSortedBy:sorting
//                                                           ascending:ascending
//                                                       withPredicate:predicate
//                                                           inContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(objectClass)];
        request.predicate = predicate;
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sorting ascending:ascending];
        request.sortDescriptors = @[sortDescriptor];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        self.fetchedResultsController = fetchedResultsController;
    }
    return self;
    
}

- (void)setPredicate:(NSPredicate *)predicate{
    [NSFetchedResultsController deleteCacheWithName:nil];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self.fetchedResultsController performFetch:NULL];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return section.numberOfObjects;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
//    if([self.delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]){
//        cell = [self.delegate tableView:self.tableView cellForRowAtIndexPath:indexPath];
//    }
    
    if(self.configureBlock){
        self.configureBlock(cell, object);
    } else if([self.delegate respondsToSelector:@selector(tableView:configureCell:withObject:)]){
        [self.delegate tableView:tableView configureCell:cell withObject:object];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return self.editingEnabled;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if([self.delegate respondsToSelector:@selector(fetchedResultsControllerTableViewDataSourceDidDeleteObject:)]){
            [self.delegate fetchedResultsControllerTableViewDataSourceDidDeleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        }
    }
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    
    
    UITableViewRowAnimation insertAnimation = UITableViewRowAnimationAutomatic;
    UITableViewRowAnimation deleteAnimation = UITableViewRowAnimationAutomatic;
    UITableViewRowAnimation reloadAnimation = UITableViewRowAnimationAutomatic;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:insertAnimation];
            
            break;
        case NSFetchedResultsChangeDelete:
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:deleteAnimation];
            
            break;
        case NSFetchedResultsChangeUpdate:
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:reloadAnimation];
            
            break;
        case NSFetchedResultsChangeMove:
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:deleteAnimation];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:insertAnimation];
            
            break;
    }
}

- (void)setFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
{
    NSAssert(_fetchedResultsController == nil, @"TODO: you can currently only assign this property once");
    _fetchedResultsController = fetchedResultsController;
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:NULL];
}


- (id)selectedItem
{
    NSIndexPath* path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}


- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    } else {
        self.fetchedResultsController.delegate = self;
//        [self.fetchedResultsController performFetch:NULL];
//        [self.tableView reloadData];
    }
}


@end