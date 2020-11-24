# Meta To Neo4j

> Project metadata lineage with Kettle/PDI and Neo4j

This project is a solution to tracking metadata lineage using Kettle and Neo4j.
Kettle is used to parse various files within a project directory. This parsed information is then written to a Neo4j graph.
Currently supported are: 
- aws (RDS, DMS)
- etl (PDI/Kettle)
- gcp (BigQuery)
- git 
- pentaho
  - mondrian (cubes, Analyzer)
  - reporting (prpt)
- rdbms (relational databases)

## Using this repository 

The checks are built in Kettle. You'll need 
- Java 8 
- Kettle/PDI: download 8.2 Remix [here](https://s3.amazonaws.com/kettle-neo4j/kettle-neo4j-remix-8.2.0.7-719-REMIX.zip) or the original 8.2. Kettle/PDI client [here](https://sourceforge.net/projects/pentaho/files/Pentaho%208.2/client-tools/pdi-ce-8.2.0.0-342.zip/download).
- clone this repository to a location on your local system.

```sh
git clone https://github.com/knowbi/knowbi-meta-to-neo4j.git
```
- make sure you have a Neo4j database running with a graph connection named 'lineage-graph' (included in the `metastore` folder). Version 4.x is advised, lower versions should also work, but may require some tweaking.
- start Spoon (with the [Neo4j plugins](https://github.com/mattcasters/knowbi-pentaho-pdi-neo4j-output) or from the [Remix](http://remix.kettle.be) and create a Neo4j connection.

## Configuration

All configuration is done through a single properties file. Copy the template file `config/meta-to-neo4j.properties.template` to a properties file `config/meta-to-neo4j.properties`. 

This file contains the following options: 

Enable or disable modules to run (all "Y" values will be included): 
- do.aws= (default: N)
- do.aws.dms= (default: Y, only if `do.aws=Y`)
- do.aws.rds= (default: Y, only if `do.aws=Y`)
- do.etl= (default: Y)
- do.gcp= (default: N)
- do.git= (default: Y)
- do.pentaho= (default: N)
- do.pentaho.report= (default: Y, only if `do.pentaho=Y`)
- do.pentaho.mondrian.schema= (default: Y, only if `do.pentaho=Y`)
- do.rdbms= (default: Y)

### AWS properties 
- aws.dms.json.dir= (default: none): the path to read the AWS config from (in JSON, support for YAML, REST may come later)

### git properties
- git.tmp.dir= (default: /tmp/): path to store temporary git information.  

### Kettle properties 
- etl.kettle.properties.dir= (default: none): the path to a kettle.properties file to take into account while parsing
- etl.dir= (default: none): the path where the Kettle/PDI jobs and transformations to be parsed are stored

### Neo4j properties 
- do.clean.neo4j.data= (default: Y): delete ALL data in the Neo4j database before processing starts (ALL really means EVERYTHING)
- neo4j.host= (default: localhost): the Neo4j database host 
- neo4j.bolt.port= (default: 7687): the Neo4j bolt port 
- neo4j.browser.port= (default: 7474): the Neo4j browser port
- neo4j.user= (default: neo4j): the Neo4j database username 
- neo4j.pass= (default: none): the Neo4j database password

### Pentaho properties 
- pentaho.mondrian.analyzer.dir= (default: none): path the Pentaho Analyzer reports
- pentaho.mondrian.properties.dir= (default: none): path to the mondrian.properties configuration file
- pentaho.mondrian.schema.dir= (default: none): path to the Mondrian schema files 
- pentaho.report.dir= (default: none): path to the Pentaho Report Designer (prpt) files

### RDBMS properties
- do.rdbms.columns= (default: Y): include columns while loading database information. If not set to 'Y', only database, schema and table information is included. 


## Parsing AWS: 

Currently, only RDS and DMS information is supported. 
**TODO**: add detailed graph model description + screenshot


## Parsing Kettle

All Kettle jobs and transformations are parsed and written to the graph model. 
This includes (but is not limited to) 
- jobs 
- job entries
- steps 
- step type
- parameter
- hops (jobs and transformations)
**TODO**: add detailed graph model description + screenshot

### Parsing Git

Git is parsed by a walk through every commit in the history of git repository. For each commit, a `git diff` is performed, the resulting output is written to the Neo4j graph. 
This includes (but is not limited to): 
- user
- commit 
- branches
- tags 

For each commit, the files that were touch are stored in a `COMMITOPERATION` relationship. 
Additionally, each commit will have a `CONTAINS` relationship to all jobs and transformations that were touched.
**TODO**: add detailed graph model description + screenshot

