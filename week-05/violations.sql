\set VERBOSITY verbose

-- Hazirlik: testleri her calistirmada ayni baslangic verisiyle baslat.
TRUNCATE TABLE event_registration, event, member, category RESTART IDENTITY CASCADE;

INSERT INTO category (name) VALUES
('Sports'),
('Arts');

INSERT INTO member (full_name, email, city, status) VALUES
('Ada Yilmaz', 'ada@example.com', 'Istanbul', 'active'),
('Bora Demir', 'bora@example.com', 'Ankara', 'active'),
('Ceren Kaya', 'ceren@example.com', 'Izmir', 'suspended');

INSERT INTO event (category_id, title, start_date, end_date, capacity) VALUES
(1, 'Running Day', '2026-11-20', '2026-11-20', 50),
(2, 'Painting Workshop', '2026-11-21', '2026-11-22', 20);

INSERT INTO event_registration (member_id, event_id, registered_at, rating) VALUES
(1, 1, '2026-11-17 10:00:00', 5);

-- T01 | category.name NOT NULL | Beklenen: 23502
INSERT INTO category (name) VALUES (NULL);

-- T02 | member.full_name NOT NULL | Beklenen: 23502
INSERT INTO member (full_name, email, city, status)
VALUES (NULL, 'null-name@example.com', 'Istanbul', 'active');

-- T03 | member.email NOT NULL | Beklenen: 23502
INSERT INTO member (full_name, email, city, status)
VALUES ('Null Email', NULL, 'Istanbul', 'active');

-- T04 | member.status NOT NULL | Beklenen: 23502
INSERT INTO member (full_name, email, city, status)
VALUES ('Null Status', 'null-status@example.com', 'Istanbul', NULL);

-- T05 | event.category_id NOT NULL | Beklenen: 23502
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (NULL, 'No Category', '2026-12-01', '2026-12-01', 10);

-- T06 | event.title NOT NULL | Beklenen: 23502
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (1, NULL, '2026-12-01', '2026-12-01', 10);

-- T07 | event.start_date NOT NULL | Beklenen: 23502
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (1, 'No Start Date', NULL, '2026-12-01', 10);

-- T08 | event.end_date NOT NULL | Beklenen: 23502
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (1, 'No End Date', '2026-12-01', NULL, 10);

-- T09 | event.capacity NOT NULL | Beklenen: 23502
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (1, 'No Capacity', '2026-12-01', '2026-12-01', NULL);

-- T10 | event_registration.member_id NOT NULL | Beklenen: 23502
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (NULL, 1, '2026-11-17 11:00:00', 4);

-- T11 | event_registration.event_id NOT NULL | Beklenen: 23502
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (2, NULL, '2026-11-17 11:05:00', 4);

-- T12 | event_registration.registered_at NOT NULL | Beklenen: 23502
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (2, 1, NULL, 4);

-- T13 | uq_member_email | Beklenen: 23505
INSERT INTO member (full_name, email, city, status)
VALUES ('Duplicate Email', 'ada@example.com', 'Bursa', 'active');

-- T14 | uq_category_name | Beklenen: 23505
INSERT INTO category (name) VALUES ('Sports');

-- T15 | uq_registration_member_event | Beklenen: 23505
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (1, 1, '2026-11-17 12:00:00', 4);

-- T16 | chk_event_capacity_positive | Beklenen: 23514
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (1, 'Zero Capacity', '2026-12-02', '2026-12-02', 0);

-- T17 | chk_member_status | Beklenen: 23514
INSERT INTO member (full_name, email, city, status)
VALUES ('Wrong Status', 'wrong-status@example.com', 'Istanbul', 'pending');

-- T18 | chk_event_date_order | Beklenen: 23514
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (1, 'Backwards Event', '2026-12-10', '2026-12-09', 10);

-- T19 | chk_registration_rating | Beklenen: 23514
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (2, 1, '2026-11-17 12:10:00', 6);

-- T20 | fk_event_category | Beklenen: 23503
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (999, 'Unknown Category Event', '2026-12-03', '2026-12-03', 10);

-- T21 | fk_registration_member | Beklenen: 23503
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (999, 1, '2026-11-17 12:20:00', 4);

-- T22 | fk_registration_event | Beklenen: 23503
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (2, 999, '2026-11-17 12:25:00', 4);

-- T23 | fk_event_category parent DELETE | Beklenen: 23503
DELETE FROM category WHERE category_id = 1;

-- T24 | chk_event_capacity_positive | Beklenen: OK (sinir: capacity = 1)
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (1, 'Capacity Boundary', '2026-12-04', '2026-12-04', 1);

-- T25 | chk_event_date_order | Beklenen: OK (sinir: ayni gun)
INSERT INTO event (category_id, title, start_date, end_date, capacity)
VALUES (1, 'Same Day Event', '2026-12-05', '2026-12-05', 10);

-- T26 | chk_registration_rating | Beklenen: OK (alt sinir: rating = 1)
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (2, 1, '2026-11-17 13:00:00', 1);

-- T27 | chk_registration_rating | Beklenen: OK (ust sinir: rating = 5)
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (3, 1, '2026-11-17 13:05:00', 5);

-- T28 | chk_registration_rating NULL testi | Beklenen: OK
INSERT INTO event_registration (member_id, event_id, registered_at, rating)
VALUES (2, 2, '2026-11-17 13:10:00', NULL);
