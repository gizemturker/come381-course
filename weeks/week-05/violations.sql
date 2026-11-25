\set VERBOSITY verbose

\echo 'NOT NULL — beklenen 23502'
INSERT INTO reader VALUES (9,NULL,'x@example.com');

\echo 'UNIQUE — beklenen 23505'
INSERT INTO reader VALUES (9,'Test','ada@example.com');

\echo 'CHECK pages — beklenen 23514'
INSERT INTO book VALUES (9,1,'Test',0);

\echo 'CHECK dates — beklenen 23514'
INSERT INTO loan VALUES (9,1,1,'2026-11-02','2026-11-01');

\echo 'FK category — beklenen 23503'
INSERT INTO book VALUES (9,99,'Test',100);

\echo 'FK reader — beklenen 23503'
INSERT INTO loan VALUES (9,99,1,'2026-11-01','2026-11-02');

\echo 'FK book — beklenen 23503'
INSERT INTO loan VALUES (9,1,99,'2026-11-01','2026-11-02');

\echo 'RESTRICT — beklenen 23503'
DELETE FROM reader WHERE reader_id=1;

\echo 'UNIQUE loan — beklenen 23505'
INSERT INTO loan VALUES (9,1,1,'2026-10-01','2026-10-15');

BEGIN;
INSERT INTO book VALUES (99,1,'Sınır testi',1);
INSERT INTO loan VALUES (99,1,99,'2026-11-01','2026-11-01');
ROLLBACK;

BEGIN;
DELETE FROM book WHERE book_id=1;
SELECT COUNT(*) AS kalan FROM loan WHERE book_id=1;
ROLLBACK;
