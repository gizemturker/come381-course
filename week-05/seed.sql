TRUNCATE TABLE event_registration, event, member, category RESTART IDENTITY CASCADE;

INSERT INTO category (name) VALUES
('Sports'),
('Arts'),
('Technology'),
('Music'),
('Community');

INSERT INTO member (full_name, email, city, status) VALUES
('Ada Yilmaz', 'ada@example.com', 'Istanbul', 'active'),
('Bora Demir', 'bora@example.com', 'Ankara', 'active'),
('Ceren Kaya', 'ceren@example.com', 'Istanbul', 'active'),
('Deniz Arslan', 'deniz@example.com', 'Izmir', 'active'),
('Ece Sahin', 'ece@example.com', 'Ankara', 'suspended'),
('Fikret Aydin', 'fikret@example.com', 'Bursa', 'active'),
('Gizem Koc', 'gizem@example.com', 'Istanbul', 'closed');

INSERT INTO event (category_id, title, start_date, end_date, capacity) VALUES
(1, 'City Run', '2026-12-01', '2026-12-01', 120),
(1, 'Basketball Cup', '2026-12-05', '2026-12-05', 40),
(1, 'Swimming Day', '2026-12-10', '2026-12-10', 80),
(2, 'Painting Workshop', '2026-12-12', '2026-12-12', 25),
(3, 'AI Seminar', '2026-12-15', '2026-12-15', 150),
(4, 'Jazz Night', '2026-12-20', '2026-12-20', 60);

INSERT INTO event_registration (member_id, event_id, registered_at, rating) VALUES
(1, 1, '2026-11-20 10:00:00', 5),
(1, 2, '2026-11-20 10:05:00', 4),
(1, 3, '2026-11-20 10:10:00', 5),
(2, 1, '2026-11-21 11:00:00', 4),
(2, 2, '2026-11-21 11:05:00', 4),
(2, 4, '2026-11-21 11:10:00', 3),
(3, 1, '2026-11-22 12:00:00', 5),
(3, 2, '2026-11-22 12:05:00', 5),
(3, 3, '2026-11-22 12:10:00', 4),
(4, 4, '2026-11-23 13:00:00', 5),
(4, 5, '2026-11-23 13:05:00', 4),
(6, 6, '2026-11-24 14:00:00', NULL),
(7, 5, '2026-11-25 15:00:00', 4);
