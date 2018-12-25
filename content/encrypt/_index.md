---
title: "Database encryption"
date: 2018-12-15
draft: false
layout: "lesson"
weight: 160
---
Right now KittyORM has no built-in functionality to provided partial or full database encryption. In future there are plans to implement AES128\256 partial encryption but what if you want to encrypt your database right now? You can use third-party solutions for this. For example, you can use such great solution as [SQLCipher](https://www.zetetic.net/sqlcipher/). So, you want to encrypt your KittyORM database with SQLCipher. Here some steps to take:

* Integrate SQLCipher into your project. For example, use this tutorial to do that: [SQLCipher for Android Application Integration](https://www.zetetic.net/sqlcipher/sqlcipher-for-android/).
* Get KittyORM library sources from [KittyORM GitHub repository](https://github.com/akaish/KittyORM) and add it to your project apart with your java sources or as AndroidStudio library module.
* Change all imports at KittyORM that import Android database classes to corresponding classes of SQLCipher. You can do it manually or run this script at KittyORM sources directory:
  {{< highlight sh >}}
#!/bin/bash
find . -name '*.java' -exec sed -i -e 's/android.database.sqlite/net.sqlcipher.database/g' {} \;
find . -name '*.java' -exec sed -i -e 's/android.database/net.sqlcipher/g' {} \;
  {{< /highlight >}} 
* Modify some methods of `KittyDatabaseHelper.class` for adding support of database encryption.
<details> 
  <summary>Click to view modified methods of `KittyDatabaseHelper.class` with encryption support: </summary>
  {{< highlight java "linenos=inline, linenostart=1">}}
public SQLiteDatabase getWritableDatabase(String pwd) {
    return super.getWritableDatabase(pwd);
}
    
public SQLiteDatabase getReadableDatabase(String pwd) {
    return super.getReadableDatabase(pwd);
}
  {{< /highlight >}} 
</details> 
* Modify constructor of `KittyDatabase.class` for adding support of database encryption.
<details> 
  <summary>Click to view modified constructor of `KittyDatabaseHelper.class` with encryption support: </summary>
  {{< highlight java "linenos=inline, linenostart=1">}}
public KittyDatabase(Context ctx, String databasePassword) {
    net.sqlcipher.database.SQLiteDatabase.loadLibs(ctx);

    ... // Old constructor code 
}
  {{< /highlight >}} 
</details> 
* And, in theory, you are ready to use KittyORM with SQLCipher. Just initialize your KittyORM database implementation using `public KittyDatabase(Context ctx, String databasePassword)` constructor. However, nobody yet tested this integration :)


