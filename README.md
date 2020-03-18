# Meta To Neo4j

> Project metadata lineage with Neo4j

This project is a solution to tracking metadata lineage using Kettle and Neo4j.
It uses Kettle to parse various files within a project directory and then writes it to a Neo4j graph.
Currently supported are: git, kettle, mondrian, rdbms and rds. It also has support for reading database structure from a database connection.

## Usage

### Parsing Kettle

1. Clone this repository to a location on your computer.

```sh
git clone https://github.com/knowbi/knowbi-meta-to-neo4j.git
```

2. Make sure you have a Neo4j database running with a graph named 'lineage-graph', version 4.0 is currently not supported so 3.5 is advised.
3. Boot up Kettle (with the Neo4j plugins) and create a Neo4j connection.
4. To start, open **jb_load_kettle_etl.kjb** in the *knowbi-meta-to-neo4j/kettle/* directory.
5. In this job there are 3 parameters:
    - PRM_ETL_DIR: The Kettle ETL directory to parse.
    - PRM_CONNECTION_NAME: Which connection to read tables, columns, queries, .. from. (optional)
    - PRM_KETTLE_PROPERTIES_DIR: The kettle.properties file directory, this is used to get the connection settings defined in the previous parameter. (optional)

6. Currently this job loads all provisioned modules; for now, to deactivate the database load (Insert DB) and rds (tr_load_rds) disable the hops and redraw hops excluding the entries.
7. Run the job.

### Parsing Git

Currently this module is run separately and is available in the git_parsing branch, this will change in a future iteration.

1. Assuming you've followed the steps above: open **jb_write_git_logs** in the *knowbi-meta-to-neo4j/kettle/* directory.
2. In this job there are 2 parameters:
    - PRM_ETL_DIR: The Kettle ETL directory to parse.
    - PRM_OUT_DIR: Temporary directory for git-python.

3. Make sure you have python 3 installed with the git-python library, or install it (your needed command may differ).

```sh
pip install gitpython
```

4. Run the job.

## Usage Example

An example of running this project on its own code, with a few screenshots.

## Release History

* 0.0.
  * Initial version, work in progress

## Branches

- Master: The main branch from which releases are made.
- essent_lineage: A branch for Essent's specific use-cases.
- git_parsing: The git module development branch.
- lineage_alignment: ..