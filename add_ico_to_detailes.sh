#!/bin/bash
#find content -name '*.md' -exec sed -i -e 's/<summary>/<summary>{{< icon name="fa-github" size="large" >}}/g' {} \;
find content -name '*.md' -exec sed -i -e 's/<summary>{{< icon name="fa-github" size="large" >}}/<summary>{{< icon name="fa-code" size="large" >}}/g' {} \;
