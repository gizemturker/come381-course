Week 05 – Constraints, SQL and Relational Algebra



Project Scenario



This assignment uses a Student Internship and Career Tracking System. It stores students, companies, internship listings, and student applications.



Files



constraints.sql: Defines UNIQUE and CHECK constraints.



violations.sql: Tests invalid inserts and updates, foreign key violations, and valid boundary cases.



violations\_output.txt: Captures the SQL test output.



on\_delete.md: Explains foreign key deletion policies.



seed.sql: Inserts sample data for testing.



algebra.md: Documents relational algebra concepts and query results.



algebra.sql: Contains the SQL queries for the exercises.



How to Run



Run the scripts in this order:



sql/schema.sql



week-05/constraints.sql



week-05/violations.sql



week-05/seed.sql



week-05/algebra.sql



Example using PostgreSQL on Windows:



\& "C:\\Program Files\\PostgreSQL\\18\\bin\\psql.exe" -U postgres -d internship\_career\_db -f sql/schema.sql

\& "C:\\Program Files\\PostgreSQL\\18\\bin\\psql.exe" -U postgres -d internship\_career\_db -f week-05/constraints.sql

\& "C:\\Program Files\\PostgreSQL\\18\\bin\\psql.exe" -U postgres -d internship\_career\_db -f week-05/violations.sql

\& "C:\\Program Files\\PostgreSQL\\18\\bin\\psql.exe" -U postgres -d internship\_career\_db -f week-05/seed.sql

\& "C:\\Program Files\\PostgreSQL\\18\\bin\\psql.exe" -U postgres -d internship\_career\_db -f week-05/algebra.sql



Note: Running sql/schema.sql recreates the tables, and running seed.sql resets the tables before inserting sample data. Run seed.sql before algebra.sql to ensure the expected sample results.



NULL and CHECK Constraints



A CHECK constraint rejects a row when its expression evaluates to FALSE. In PostgreSQL, an expression evaluating to UNKNOWN because of NULL does not fail a CHECK constraint. Therefore, a separate NOT NULL constraint is needed when NULL values must be prohibited.



What I Learned



I learned how UNIQUE, CHECK, NOT NULL, and foreign key constraints protect data integrity. I also practiced relational algebra operations such as selection, projection, UNION, INTERSECT, EXCEPT, joins, and division-style queries using nested NOT EXISTS.

