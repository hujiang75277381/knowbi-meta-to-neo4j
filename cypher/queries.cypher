// find all paths for jobs that contain transformations with a Database Lookup step  
match (j:Job), (st:StepType {name: "DBLookup"}), p = allShortestPaths((j)-[*]-(st)) 
WHERE NONE(x IN RELATIONSHIPS(p) WHERE type(x) = "HAS_CONNECTION" or type(x) = "USES_CONNECTION" )
return p;


// find all paths for jobs that use columns tb_dim_driver.driver_number 
match (j:Job), (c:Column {name: "driver_number", table: "tb_dim_driver"}), p = allShortestPaths((j)-[*]->(c)) 
WHERE NONE(x IN RELATIONSHIPS(p) WHERE type(x) = "HAS_COLUMN")
return p;

- why:
    - logging information isn't hard
    - retrieving useful information and finding relations between data points and events IS hard
- why graph databases:
    - focus on relations
    - path finding, graph algorithms allow to find all (known and unknown) relations between two data points, their centrality, connectedness, ...
      --> SQL requires you to know *what* you are looking for, no such this as path finding
- what: store everything!
    - Infrastructure
    - Kettle/Hop execution logs
    - user access rights
    - user activity
    - query execution logs, ...
- use cases:
    - investigate which users performed a given activity
    - check execution information
    - find out which users will be impacted by a database change
    - find end-to-end lineage between a data file or source system column and a dimension or fact record
    - ...
- Next
	- Git
	- AD

Demo
	A data lineage framework with Kettle and Neo4J
//list all jobs and transformations
match(n) where labels(n) =['Transformation'] or labels(n)=['Job'] return n.name, labels(n)

//list all db info
match(n:Column)-[r]-(m:DataType) return n.database, n.schema, n.table, n.column, m.datatype

//ean
match(n:Column) where n.column='ean' return n.column, n.table, n.schema, n.database

//ean list adjust transformation
match (j:Transformation), (c:Column {column: "ean"}), p = allShortestPaths((j)-[*]->(c)) WHERE NONE(x IN RELATIONSHIPS(p) WHERE type(x) = "HAS_COLUMN") return j.name

//ean graph adjust transformation
match (j:Transformation), (c:Column {column: "ean"}), p = allShortestPaths((j)-[*]->(c)) WHERE NONE(x IN RELATIONSHIPS(p) WHERE type(x) = "HAS_COLUMN") return p

//reload
match (j:Job), (c:Column {column: "ean"}), p = allShortestPaths((j)-[*]->(c)) WHERE NONE(x IN RELATIONSHIPS(p) WHERE type(x) = "HAS_COLUMN") return p

//point
call db.schema()

//transformation
match (m:Job) where m.name='jb_fact_client_asks_cdc' return m

//AWS
match(n:Database {database:'dwh'}) return n
