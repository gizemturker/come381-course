-- Bölüm D için küçük veri seti. Kendi başına çalışır (önce tabloları boşaltır).
TRUNCATE loan, book_copy, book_author, book, author, publisher, member
  RESTART IDENTITY CASCADE;

INSERT INTO publisher (name) VALUES
  ('Can Yayinlari'),
  ('Iletisim'),
  ('Yapi Kredi Yayinlari'),
  ('Penguin Books'),
  ('Metis');

INSERT INTO author (full_name, country) VALUES
  ('Sabahattin Ali',   'TR'),   -- 1
  ('Orhan Pamuk',      'TR'),   -- 2
  ('Elif Safak',       'TR'),   -- 3
  ('George Orwell',    'GB'),   -- 4
  ('Ursula K. Le Guin','US'),   -- 5
  ('Neil Gaiman',      'GB'),   -- 6
  ('Terry Pratchett',  'GB');   -- 7

INSERT INTO book (publisher_id, title, isbn, publication_year) VALUES
  (1, 'Kurk Mantolu Madonna', '978-975-07-0001-1', 1943),  -- 1
  (1, 'Kuyucakli Yusuf',      '978-975-07-0002-8', 1937),  -- 2
  (2, 'Kar',                  '978-975-07-0003-5', 2002),  -- 3
  (3, 'Ask',                  '978-975-07-0004-2', 2009),  -- 4
  (4, '1984',                 '978-975-07-0005-9', 1949),  -- 5
  (5, 'Mulksuzler',           '978-975-07-0006-6', 1974),  -- 6
  (4, 'Good Omens',           '978-975-07-0007-3', 1990);  -- 7

-- M:N: Good Omens'in iki yazarı var
INSERT INTO book_author (book_id, author_id) VALUES
  (1, 1), (2, 1), (3, 2), (4, 3), (5, 4), (6, 5), (7, 6), (7, 7);

INSERT INTO book_copy (book_id, shelf_code, purchase_price) VALUES
  (1, 'A-01',  85.00),  -- 1
  (1, 'A-02',  85.00),  -- 2
  (2, 'A-03',  70.00),  -- 3
  (2, 'A-04',  70.00),  -- 4
  (3, 'B-01', 120.00),  -- 5
  (4, 'B-02',  95.00),  -- 6
  (5, 'C-01', 110.00),  -- 7
  (5, 'C-02', 110.00),  -- 8
  (6, 'C-03', 130.00),  -- 9
  (7, 'D-01', 140.00);  -- 10

INSERT INTO member (full_name, email, joined_date, status) VALUES
  ('Ayse Demir',    'ayse@example.com',   '2026-01-05', 'active'),     -- 1
  ('Mehmet Kaya',   'mehmet@example.com', '2026-01-08', 'active'),     -- 2
  ('Zeynep Arslan', 'zeynep@example.com', '2026-01-20', 'active'),     -- 3
  ('Can Yilmaz',    'can@example.com',    '2026-02-01', 'active'),     -- 4
  ('Elif Celik',    'elif@example.com',   '2026-02-03', 'active'),     -- 5
  ('Burak Sahin',   'burak@example.com',  '2026-02-15', 'active'),     -- 6
  ('Deniz Aydin',   'deniz@example.com',  '2026-03-01', 'active'),     -- 7 (hiç ödünç almadı)
  ('Selin Ozturk',  'selin@example.com',  '2026-03-10', 'suspended');  -- 8 (hiç ödünç almadı)

INSERT INTO loan (member_id, copy_id, loan_date, due_date, return_date) VALUES
  (1,  1, '2026-01-12', '2026-01-26', '2026-01-20'),  -- Ayse: kitap 1
  (1,  3, '2026-02-01', '2026-02-15', '2026-02-14'),  -- Ayse: kitap 2
  (2,  2, '2026-01-15', '2026-01-29', '2026-01-28'),  -- Mehmet: kitap 1
  (2,  4, '2026-02-10', '2026-02-24', '2026-02-22'),  -- Mehmet: kitap 2
  (2,  7, '2026-05-01', '2026-05-15', NULL),          -- Mehmet: kitap 5 (iade edilmedi)
  (3,  1, '2026-03-20', '2026-04-03', '2026-04-01'),  -- Zeynep: kitap 1
  (3,  2, '2026-04-05', '2026-04-19', '2026-04-18'),  -- Zeynep: kitap 1 (başka nüsha, aynı kitap!)
  (4,  1, '2026-05-10', '2026-05-24', '2026-05-20'),  -- Can: kitap 1
  (4,  5, '2026-06-20', '2026-07-04', '2026-07-01'),  -- Can: kitap 3
  (4,  7, '2026-07-10', '2026-07-24', NULL),          -- Can: kitap 5 (iade edilmedi)
  (5,  5, '2026-02-05', '2026-02-19', '2026-02-18'),  -- Elif: kitap 3
  (5,  6, '2026-03-05', '2026-03-19', '2026-03-17'),  -- Elif: kitap 4
  (6,  6, '2026-04-02', '2026-04-16', '2026-04-15'),  -- Burak: kitap 4
  (6,  8, '2026-06-05', '2026-06-19', '2026-06-18');  -- Burak: kitap 5
