---
title: "KittyORM and bulk operations"
date: 2018-12-15
draft: false
weight: 5
layout: "lesson"
---
{{% panel footer="Demo application screenshots for this article" %}}
<center>![alt text](src/1.png?height=150px&classes=border,inline)  ![alt text](src/2.png?height=150px&classes=border,inline) ![alt text](src/3.png?height=150px&classes=border,inline)</center>
{{% /panel %}}

KittyORM by design provides several methods for updating, inserting and deleting collections of entities. If you want to save a collection of entities just call `save(List<M> models)` method of `KittyMapper.class` or its implementation and all models in provided collections would be updated or inserted (KittyORM would make a decision on this by processing POJO fields that can be used for unambiguous record definition in source table). Also, you can run update or insert methods directly, if you are sure that collection contains only new or existing entities. This approach also applicable for `delete(List<M> models)` method of `KittyMapper.class` and its implementations. Take a look at this example of bulk operations using `KittyMapper.class` CRUD controller:
{{< highlight java "linenos=inline, linenostart=1">}}
// Initializing database instance
BasicDatabase db = new BasicDatabase(getContext());
// Getting mapper instance
RandomMapper mapper = (RandomMapper) db.getMapper(RandomModel.class);
// Generating list of entities to insert
List<RandomModel> toSave = new ArrayList<>();
// Filling this list with randomly generated POJOs
RNDRandomModelFactory rndFactory = new RNDRandomModelFactory(getContext());
for(int i = 0; i < 100; i++) {
    toSave.add(rndFactory.newRandomModel());
}
// Running bulk save
mapper.save(toSave);
{{< /highlight >}}

{{% panel theme="warning" footer="Tip #1" %}}
Be aware of deleting entities with `delete(List<M> models)` that you are received from `findWhere(SQLiteCondition where, QueryParameters qParams)` (or other `find` method) with any clause. It's not necessary, just use `deleteWhere(SQLiteCondition condition)` with this clause, it is much faster.
{{% /panel %}}

### KittyORM and bulk operations in transaction mode
Using a lot of separate insertions is not really fast, because for each such operation SQLite would start its own query and this operation costs time. However, what to do when there are a lot of insertions (or record updates)? Just force KittyMapper to apply all your operations in transaction mode. This would force SQLite to run all your statements as a one query and this can speed up execution time of insertions up to 20x. It's really useful feature when you need to save at your database big amounts of data. So, you can run your database write operations in transaction in two different ways:

1. Apply bulk operation in transaction mode:
{{< highlight java "linenos=inline, linenostart=1">}}
// Initializing database instance
BasicDatabase db = new BasicDatabase(getContext());
// Getting mapper instance
RandomMapper mapper = (RandomMapper) db.getMapper(RandomModel.class);
// Generating list of entities to insert
List<RandomModel> toSave = new ArrayList<>();
// Filling this list with randomly generated POJOs
RNDRandomModelFactory rndFactory = new RNDRandomModelFactory(getContext());
for(int i = 0; i < 100; i++) {
    toSave.add(rndFactory.newRandomModel());
}
// Running bulk save in transaction
mapper.saveInTransaction(toSave);
{{< /highlight >}}

2. Start transaction manually, do all your write operations and finish transaction:
{{< highlight java "linenos=inline, linenostart=1">}}
// Initializing database instance
BasicDatabase db = new BasicDatabase(getContext());
// Getting mapper instance
RandomMapper mapper = (RandomMapper) db.getMapper(RandomModel.class);
// Generating list of entities to insert
List<RandomModel> toInsert = new ArrayList<>();
// Filling this list with randomly generated POJOs
RNDRandomModelFactory rndFactory = new RNDRandomModelFactory(getContext());
for(int i = 0; i < 100; i++) {
    toInsert.add(rndFactory.newRandomModel());
}
// Starting transaction for your database write operations
startTransaction(TRANSACTION_MODES.NON_EXCLUSIVE_MODE);
// Running some write database operations
mapper.insert(toSave);
SQLiteConditionBuilder builder = new SQLiteConditionBuilder();
builder.addColumn(AbstractRandomModel.RND_ANIMAL_CNAME)
       .addSQLOperator(SQLiteOperator.EQUAL)
       .addValue(Animals.DOG.name());
mapper.deleteWhere();
// Finishing transaction
finishTransaction();
{{< /highlight >}}

{{% panel theme="warning" footer="Tip #2" %}}
You may start your transaction in three modes: `TRANSACTION_MODES.EXCLUSIVE_MODE`, `TRANSACTION_MODES.NON_EXCLUSIVE_MODE` (API level 11 and higher) and `TRANSACTION_MODES.LOCKING_FALSE_MODE` (deprecated in API level 16). By default, `KittyMapper.startTransaction()` would start transaction in `EXCLUSIVE_MODE`. Refer to official Android documentation about transaction modes for more info.
{{% /panel %}}
