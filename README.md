# The Warren

A tool for tracking the relationships between people, groups, places and more.

# Setup

## Java

You need Oracle's Java 7 runtime environment to use this tool.

* [Java for OS X](http://java.com/en/download/mac_download.jsp)

## Neo4j

This app uses the latest 2.0 version of neo4j. You can download that directly at:

* [Neo4j-2.0.0-M05](http://dist.neo4j.org/neo4j-community-2.0.0-M05-unix.tar.gz?edition=community&version=2.0.0-M05&distribution=tarball&dlid=2603331)

# Usage

This is currently just a collection of scripts to populate neo4j. You should copy the data in data/shabaab.cypher and paste it into the neo4j 'power console' in its web admin to start.

```
cat data/shabaab.cypher | pbcopy
open http://localhost:7474/webadmin/#/console/
```

Paste in the console, hit enter. You should see something like the following response:

```
==> +-------------------+
==> | No data returned. |
==> +-------------------+
==> Nodes created: 9
==> Relationships created: 9
==> Properties set: 29
==> Labels added: 9
==> 197 ms
neo4j-sh (0)$ 
```

