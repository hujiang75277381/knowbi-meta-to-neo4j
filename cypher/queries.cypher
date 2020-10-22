// find all paths for jobs that contain transformations with a Database Lookup step  
match (j:Job), (st:StepType {name: "DBLookup"}), p = allShortestPaths((j)-[*]-(st)) 
WHERE NONE(x IN RELATIONSHIPS(p) WHERE type(x) = "HAS_CONNECTION" or type(x) = "USES_CONNECTION" )
return p;


// find all paths for jobs that use columns tb_dim_driver.driver_number 
match (j:Job), (c:Column {name: "driver_number", table: "tb_dim_driver"}), p = allShortestPaths((j)-[*]->(c)) 
WHERE NONE(x IN RELATIONSHIPS(p) WHERE type(x) = "HAS_COLUMN")
return p;


// find all different combinations of connections, with their transformation/job count
match(t:Transformation)-[:HAS_CONNECTION]-(c:Connection)
match(c:Connection)-[:DB_CONNECTION]-(d1:Database)
match(d2:Database)-[:DB_PORT]-(p:Port)
match(d3:Database)-[:DB_HOST]-(s:Server)
where d1 = d2 
  and d1 = d3
return c.name, d1.name, s.name, p.number, count(distinct t.name)   
order by c.name, d1.name, s.name, p.number, count(distinct t.name)


// find transformations that have a relationship from TableInput to SelectValues 
match p=(t:Transformation)-[sot:STEP_OF_TRANSFORMATION]-(s1:Step)-[:WRITES_TO]->(s2:Step) where s1.pluginId in ['TableInput','TextFileInput'] and s2.pluginId in ['SelectValues', 'FilterRows'] return p limit 40;


// find all transformations with at most 10 steps that have (e.g.) a TextFileInput -> SelectValues sequence (potential candidates for metadata injection)
match (t:Transformation)-[sot:STEP_OF_TRANSFORMATION]-(s1:Step {pluginId: "TextFileInput"})-[:WRITES_TO]->(s2:Step {pluginId: "SelectValues"}) 
CALL {
  WITH t 
  MATCH(t)-[:STEP_OF_TRANSFORMATION]-(s:Step) with count(s) as nbsteps where nbsteps <= 10 return nbsteps
}
return *
;