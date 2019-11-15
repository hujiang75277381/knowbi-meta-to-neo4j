// find all paths for jobs that contain transformations with a Database Lookup step  
match (j:Job), (st:StepType {name: "DBLookup"}), p = allShortestPaths((j)-[*]-(st)) 
WHERE NONE(x IN RELATIONSHIPS(p) WHERE type(x) = "HAS_CONNECTION" or type(x) = "USES_CONNECTION" )
return p;


// find all paths for jobs that use columns tb_dim_driver.driver_number 
match (j:Job), (c:Column {name: "driver_number", table: "tb_dim_driver"}), p = allShortestPaths((j)-[*]->(c)) 
WHERE NONE(x IN RELATIONSHIPS(p) WHERE type(x) = "HAS_COLUMN")
return p;
