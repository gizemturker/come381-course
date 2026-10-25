Foreign Key Delete Policies



1\. Student–Application: ON DELETE CASCADE



The foreign key application.student\_id references student.student\_id with ON DELETE CASCADE.



Reason: When a student is deleted, their applications are deleted automatically. This is appropriate for demonstrating cascading deletion, although a production system may prefer to preserve application history.



2\. Internship–Application: ON DELETE NO ACTION



The foreign key application.internship\_id references internship.internship\_id using the default NO ACTION behavior.



Reason: An internship cannot be deleted while applications reference it. This protects application records from losing their internship context.



3\. Company–Internship: ON DELETE NO ACTION



The foreign key internship.company\_id references company.company\_id using the default NO ACTION behavior.



Reason: A company cannot be deleted while it has internship listings. The listings must be handled first.



CASCADE Demonstration



The following commands demonstrate cascading deletion using the schema's application.student\_id foreign key. Run them after loading the sample data. The transaction is rolled back so the sample data remains unchanged.



BEGIN;



SELECT COUNT(\*) AS applications\_before

FROM application

WHERE student\_id = 1;



DELETE FROM student

WHERE student\_id = 1;



SELECT COUNT(\*) AS applications\_after

FROM application

WHERE student\_id = 1;



ROLLBACK;



Expected result: applications\_before is greater than zero, while applications\_after is zero because the student's applications are deleted automatically. ROLLBACK restores the deleted student and applications.



RESTRICT vs. NO ACTION



RESTRICT prevents deletion when dependent rows exist. NO ACTION checks referential integrity when the constraint is checked and may allow deferred checking if the constraint is deferrable.



Summary



This design demonstrates two deletion policies: CASCADE for student applications and NO ACTION for internship and company relationships. The policy should be chosen according to whether dependent records should be automatically deleted or preserved.

