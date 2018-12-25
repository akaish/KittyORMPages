---
title: "Source code"
date: 2018-12-15
draft: false
layout: "lesson"
weight: 1
pre: "<i class='fa fa-code'>&nbsp;</i> "
---
##### Example of KittyORM logging setup:
{{< highlight java "linenos=inline, linenostart=1">}}
@KITTY_DATABASE(
        isLoggingOn = true, // Base logging flag
        isProductionOn = false, // Production logging flag
        isKittyDexUtilLoggingEnabled = false, // dex logging flag
        logTag = MigrationDBv3.LTAG, // log tag
        databaseName = "mig", // database name
        databaseVersion = 3, // database version
        ...
)

public class MigrationDBv3 extends KittyDatabase {

    public static final String LTAG = "MIGv3";
    
    ...
}
{{< /highlight >}}

##### Example of `KittyModel` implementaion `toLogString()` method overload:

{{< highlight java "linenos=inline, linenostart=1">}}
@KITTY_TABLE
public class SimpleExampleModel extends KittyModel {
    public SimpleExampleModel() {
        super();
    }

    @KITTY_COLUMN(
            isIPK = true,
            columnOrder = 0
    )
    public Long id;

    @KITTY_COLUMN(columnOrder = 1)
    public int randomInteger;

    @KITTY_COLUMN(columnOrder = 2)
    public String firstName;

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder(64);
        return sb.append("[ rowid = ")
                    .append(getRowID())
                    .append(" ; id = ")
                    .append(id)
                    .append(" ; randomInteger = ")
                    .append(randomInteger)
                    .append(" ; firstName = ")
                    .append(firstName)
                    .append(" ]")
                    .toString();
    }

    public String toLogString() {
        return toString();
    }
}
{{< /highlight >}}
