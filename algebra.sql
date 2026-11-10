-- 1: Selection + projection
SELECT title FROM workshop WHERE capacity > 10;
-- 2: Join
SELECT c.full_name, w.title FROM customer c
JOIN registration r ON r.customer_id=c.customer_id
JOIN workshop w ON w.workshop_id=r.workshop_id;
-- 3: Union
SELECT customer_id FROM registration WHERE workshop_id=1
UNION SELECT customer_id FROM registration WHERE workshop_id=2;
-- 4: Intersection
SELECT customer_id FROM registration WHERE workshop_id=1
INTERSECT SELECT customer_id FROM registration WHERE workshop_id=2;
-- 5: Difference
SELECT customer_id FROM registration WHERE workshop_id=1
EXCEPT SELECT customer_id FROM registration WHERE workshop_id=2;
-- 6: Division (relational division using NOT EXISTS)
SELECT c.customer_id, c.full_name FROM customer c
WHERE NOT EXISTS (
 SELECT 1 FROM workshop w
 WHERE NOT EXISTS (
  SELECT 1 FROM registration r
  WHERE r.customer_id=c.customer_id AND r.workshop_id=w.workshop_id
 )
);
