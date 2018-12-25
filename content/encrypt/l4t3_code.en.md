---
title: "Source code"
date: 2018-12-15
draft: false
layout: "lesson"
weight: 1
pre: "<i class='fa fa-code'>&nbsp;</i> "
---
##### Example script for changing all imports at KittyORM that import Android database classes to corresponding classes of SQLCipher:
{{< highlight sh >}}
#!/bin/bash
find . -name '*.java' -exec sed -i -e 's/android.database.sqlite/net.sqlcipher.database/g' {} \;
find . -name '*.java' -exec sed -i -e 's/android.database/net.sqlcipher/g' {} \;
{{< /highlight >}} 
##### Modifying methods of `KittyDatabaseHelper.class` for encryption support:
{{< highlight java "linenos=inline, linenostart=1">}}
public SQLiteDatabase getWritableDatabase(String pwd) {
    return super.getWritableDatabase(pwd);
}
    
public SQLiteDatabase getReadableDatabase(String pwd) {
    return super.getReadableDatabase(pwd);
}
{{< /highlight >}} 
##### Modifying сonstructor of `KittyDatabase.class` for adding support of database encryption:
{{< highlight java "linenos=inline, linenostart=1">}}
public KittyDatabase(Context ctx, String databasePassword) {
    net.sqlcipher.database.SQLiteDatabase.loadLibs(ctx);

    ... // Old constructor code 
}
{{< /highlight >}} 
