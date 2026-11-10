\set VERBOSITY verbose

-- ============================================================
-- Hazırlık: tabloları boşalt, testlerin ihtiyaç duyduğu satırları ekle
-- ============================================================
TRUNCATE loan, book_copy, book_author, book, author, publisher, member
  RESTART IDENTITY CASCADE;

INSERT INTO publisher (name) VALUES ('Can Yayinlari');
INSERT INTO author (full_name, country) VALUES ('Sabahattin Ali', 'TR');
INSERT INTO book (publisher_id, title, isbn, publication_year)
  VALUES (1, 'Kurk Mantolu Madonna', '978-975-07-0001-1', 1943);
INSERT INTO book_author (book_id, author_id) VALUES (1, 1);
INSERT INTO book_copy (book_id, shelf_code, purchase_price) VALUES (1, 'A-01', 85.00);
INSERT INTO member (full_name, email, joined_date)
  VALUES ('Ayse Demir', 'ayse@example.com', '2026-01-10');
INSERT INTO loan (member_id, copy_id, loan_date, due_date)
  VALUES (1, 1, '2026-03-01', '2026-03-15');

-- ============================================================
-- NOT NULL
-- ============================================================

-- T01 | member.full_name NOT NULL | Beklenen: 23502
INSERT INTO member (full_name, email, joined_date)
VALUES (NULL, 'null-name@example.com', '2026-01-11');

-- T02 | loan.due_date NOT NULL | Beklenen: 23502
INSERT INTO loan (member_id, copy_id, loan_date, due_date)
VALUES (1, 1, '2026-09-01', NULL);

-- ============================================================
-- UNIQUE
-- ============================================================

-- T03 | uq_member_email | Beklenen: 23505
INSERT INTO member (full_name, email, joined_date)
VALUES ('Baska Ayse', 'ayse@example.com', '2026-01-12');

-- T04 | uq_book_isbn | Beklenen: 23505
INSERT INTO book (publisher_id, title, isbn, publication_year)
VALUES (1, 'Ayni ISBN', '978-975-07-0001-1', 1950);

-- T05 | uq_book_copy_shelf_code | Beklenen: 23505
INSERT INTO book_copy (book_id, shelf_code, purchase_price)
VALUES (1, 'A-01', 50.00);

-- T06 | uq_loan_copy_loan_date (çok sütunlu) | Beklenen: 23505
INSERT INTO loan (member_id, copy_id, loan_date, due_date)
VALUES (1, 1, '2026-03-01', '2026-03-10');

-- T07 | book_author_pkey (birleşik birincil anahtar) | Beklenen: 23505
INSERT INTO book_author (book_id, author_id) VALUES (1, 1);

-- ============================================================
-- CHECK
-- ============================================================

-- T08 | chk_book_copy_price_positive | Beklenen: 23514
INSERT INTO book_copy (book_id, shelf_code, purchase_price)
VALUES (1, 'A-02', 0);

-- T09 | chk_book_copy_price_positive | Beklenen: OK (sınır: 0.01)
INSERT INTO book_copy (book_id, shelf_code, purchase_price)
VALUES (1, 'A-02', 0.01);

-- T10 | chk_member_status | Beklenen: 23514
INSERT INTO member (full_name, email, joined_date, status)
VALUES ('Yasakli Uye', 'banned@example.com', '2026-01-13', 'banned');

-- T11 | chk_book_publication_year | Beklenen: 23514
INSERT INTO book (publisher_id, title, isbn, publication_year)
VALUES (1, 'Cok Eski Kitap', '978-975-07-0002-8', 1200);

-- T12 | chk_book_publication_year | Beklenen: OK (sınır: 1450)
INSERT INTO book (publisher_id, title, isbn, publication_year)
VALUES (1, 'Sinirdaki Kitap', '978-975-07-0003-5', 1450);

-- T13 | chk_loan_date_order | Beklenen: 23514
INSERT INTO loan (member_id, copy_id, loan_date, due_date)
VALUES (1, 1, '2026-07-10', '2026-07-01');

-- T14 | chk_loan_date_order | Beklenen: OK (sınır: aynı gün)
INSERT INTO loan (member_id, copy_id, loan_date, due_date)
VALUES (1, 1, '2026-04-01', '2026-04-01');

-- T15 | chk_loan_return_order | Beklenen: 23514
INSERT INTO loan (member_id, copy_id, loan_date, due_date, return_date)
VALUES (1, 1, '2026-06-01', '2026-06-15', '2026-05-30');

-- T16 | chk_loan_return_order | Beklenen: OK (NULL testi: return_date NULL)
INSERT INTO loan (member_id, copy_id, loan_date, due_date, return_date)
VALUES (1, 1, '2026-05-01', '2026-05-15', NULL);

-- ============================================================
-- FOREIGN KEY (iki yön + silme politikaları)
-- ============================================================

-- T17 | fk_loan_member (INSERT: olmayan üye) | Beklenen: 23503
INSERT INTO loan (member_id, copy_id, loan_date, due_date)
VALUES (999, 1, '2026-08-01', '2026-08-15');

-- T18 | fk_loan_member (UPDATE: olmayan üyeye taşıma) | Beklenen: 23503
UPDATE loan SET member_id = 999 WHERE loan_id = 1;

-- T19 | fk_loan_member (DELETE, RESTRICT: ödünç kaydı olan üye) | Beklenen: 23503
DELETE FROM member WHERE member_id = 1;

-- T20 | fk_loan_copy (DELETE, NO ACTION: ödünç kaydı olan nüsha) | Beklenen: 23503
DELETE FROM book_copy WHERE copy_id = 1;

-- T21 | fk_book_copy_book (DELETE, RESTRICT: nüshası olan kitap) | Beklenen: 23503
DELETE FROM book WHERE book_id = 1;

-- T22 | fk_book_publisher (DELETE, SET NULL) | Beklenen: OK, kitabın yayınevi NULL olur
DELETE FROM publisher WHERE publisher_id = 1;
SELECT book_id, publisher_id FROM book WHERE book_id = 1;

-- T23 | fk_book_author_author (DELETE, CASCADE) | Beklenen: OK, bağlantı satırı da silinir
DELETE FROM author WHERE author_id = 1;
SELECT count(*) AS remaining_links FROM book_author WHERE author_id = 1;
