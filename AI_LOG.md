AI Usage Log



Ödev 1



I used AI assistance to organize the Student Internship and Career Tracking System scenario and review the database design. I checked that the schema contained the required entities, primary keys, foreign keys, and the many-to-many relationship between students and internships through the application table. I reviewed the generated SQL and adjusted the design to match the project requirements.



Ödev 2



Prompt



Write PostgreSQL queries using relational algebra concepts for a Student Internship and Career Tracking System. Include selection, projection, joins, UNION, INTERSECT, EXCEPT, and a division-style query that finds students who applied to every internship published by companies in the sports industry.



AI Assistance



AI helped draft SQL queries using SELECT, JOIN, UNION, INTERSECT, EXCEPT, and nested NOT EXISTS. It also explained how the SQL queries correspond to relational algebra operations.



Evaluation and Testing



I executed the queries against the sample database and checked the results. The division-style query returned students who had applied to every sports-industry internship in the sample data. The EXCEPT and NOT EXISTS approaches both identified students who had not submitted any applications.



I also considered a near-counterexample: a student who applied to one sports internship but not all of them should not appear in the division-style query result. This helped verify that the query checks every required internship rather than just one.

