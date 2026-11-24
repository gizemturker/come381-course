-- Bu dosya sql/schema.sql'den SONRA çalışır.
-- Ödev 1'deki isimsiz foreign key'ler önce silinir, sonra isimli ve
-- silme politikalı (ON DELETE) olarak yeniden eklenir.

-- ============================================================
-- Yeni sütun: üyelik durumu (izin verilen değerler CHECK'i için)
-- ============================================================
ALTER TABLE member ADD COLUMN status text NOT NULL DEFAULT 'active';

-- ============================================================
-- NOT NULL
-- ============================================================
-- Her üyenin adı, e-postası ve katılım tarihi olmalı.
ALTER TABLE member ALTER COLUMN full_name   SET NOT NULL;
ALTER TABLE member ALTER COLUMN email       SET NOT NULL;
ALTER TABLE member ALTER COLUMN joined_date SET NOT NULL;

-- Her yayınevinin ve yazarın bir adı olmalı.
ALTER TABLE publisher ALTER COLUMN name      SET NOT NULL;
ALTER TABLE author    ALTER COLUMN full_name SET NOT NULL;

-- Her kitabın başlığı, ISBN'i ve yayın yılı olmalı.
-- (publisher_id bilerek NULL olabilir: yayınevi silinince SET NULL uygulanır.)
ALTER TABLE book ALTER COLUMN title            SET NOT NULL;
ALTER TABLE book ALTER COLUMN isbn             SET NOT NULL;
ALTER TABLE book ALTER COLUMN publication_year SET NOT NULL;

-- Her nüsha bir kitaba bağlı olmalı, raf kodu ve alış fiyatı bulunmalı.
ALTER TABLE book_copy ALTER COLUMN book_id        SET NOT NULL;
ALTER TABLE book_copy ALTER COLUMN shelf_code     SET NOT NULL;
ALTER TABLE book_copy ALTER COLUMN purchase_price SET NOT NULL;

-- Her ödünç kaydında kim, hangi nüsha, ne zaman ve son teslim tarihi olmalı.
-- (return_date bilerek NULL olabilir: kitap henüz iade edilmemiş demektir.)
ALTER TABLE loan ALTER COLUMN member_id SET NOT NULL;
ALTER TABLE loan ALTER COLUMN copy_id   SET NOT NULL;
ALTER TABLE loan ALTER COLUMN loan_date SET NOT NULL;
ALTER TABLE loan ALTER COLUMN due_date  SET NOT NULL;

-- ============================================================
-- UNIQUE
-- ============================================================
-- İki üye aynı e-posta adresini kullanamaz.
ALTER TABLE member
  ADD CONSTRAINT uq_member_email UNIQUE (email);

-- Aynı isimde iki yayınevi olamaz.
ALTER TABLE publisher
  ADD CONSTRAINT uq_publisher_name UNIQUE (name);

-- Aynı ISBN'li iki kitap kaydı olamaz.
ALTER TABLE book
  ADD CONSTRAINT uq_book_isbn UNIQUE (isbn);

-- Aynı raf koduna sahip iki nüsha olamaz.
ALTER TABLE book_copy
  ADD CONSTRAINT uq_book_copy_shelf_code UNIQUE (shelf_code);

-- Bir nüsha aynı gün iki kez ödünç verilemez. (çok sütunlu)
ALTER TABLE loan
  ADD CONSTRAINT uq_loan_copy_loan_date UNIQUE (copy_id, loan_date);

-- ============================================================
-- CHECK
-- ============================================================
-- Bir nüshanın alış fiyatı sıfırdan büyük olmalı. (tek sütun, aralık)
ALTER TABLE book_copy
  ADD CONSTRAINT chk_book_copy_price_positive
  CHECK (purchase_price > 0);

-- Yayın yılı matbaanın icadından önce ya da 2100'den sonra olamaz. (tek sütun, aralık)
ALTER TABLE book
  ADD CONSTRAINT chk_book_publication_year
  CHECK (publication_year BETWEEN 1450 AND 2100);

-- Üye durumu yalnızca üç değerden biri olabilir. (izin verilen değerler)
ALTER TABLE member
  ADD CONSTRAINT chk_member_status
  CHECK (status IN ('active', 'suspended', 'closed'));

-- Son teslim tarihi ödünç alma gününden önce olamaz. (iki sütun)
ALTER TABLE loan
  ADD CONSTRAINT chk_loan_date_order
  CHECK (due_date >= loan_date);

-- Kitap, ödünç alınmadan önce iade edilemez. (iki sütun)
-- Not: return_date NULL ise (henüz iade edilmedi) koşul "bilinmiyor" döner
-- ve PostgreSQL satırı kabul eder; bu yüzden ayrıca IS NULL yazmadık.
ALTER TABLE loan
  ADD CONSTRAINT chk_loan_return_order
  CHECK (return_date >= loan_date);

-- ============================================================
-- FOREIGN KEY: isimli ve silme politikalı (ayrıntı: on_delete.md)
-- ============================================================
ALTER TABLE book         DROP CONSTRAINT IF EXISTS book_publisher_id_fkey;
ALTER TABLE book_author  DROP CONSTRAINT IF EXISTS book_author_book_id_fkey;
ALTER TABLE book_author  DROP CONSTRAINT IF EXISTS book_author_author_id_fkey;
ALTER TABLE book_copy    DROP CONSTRAINT IF EXISTS book_copy_book_id_fkey;
ALTER TABLE loan         DROP CONSTRAINT IF EXISTS loan_member_id_fkey;
ALTER TABLE loan         DROP CONSTRAINT IF EXISTS loan_copy_id_fkey;

-- Yayınevi silinirse kitap kalır, yayınevi bilgisi boşalır.
ALTER TABLE book
  ADD CONSTRAINT fk_book_publisher
  FOREIGN KEY (publisher_id) REFERENCES publisher (publisher_id)
  ON DELETE SET NULL;

-- Kitap silinirse kitap-yazar bağlantıları da silinir.
ALTER TABLE book_author
  ADD CONSTRAINT fk_book_author_book
  FOREIGN KEY (book_id) REFERENCES book (book_id)
  ON DELETE CASCADE;

-- Yazar silinirse kitap-yazar bağlantıları silinir, kitap kalır.
ALTER TABLE book_author
  ADD CONSTRAINT fk_book_author_author
  FOREIGN KEY (author_id) REFERENCES author (author_id)
  ON DELETE CASCADE;

-- Nüshası olan kitap silinemez.
ALTER TABLE book_copy
  ADD CONSTRAINT fk_book_copy_book
  FOREIGN KEY (book_id) REFERENCES book (book_id)
  ON DELETE RESTRICT;

-- Ödünç geçmişi olan üye silinemez.
ALTER TABLE loan
  ADD CONSTRAINT fk_loan_member
  FOREIGN KEY (member_id) REFERENCES member (member_id)
  ON DELETE RESTRICT;

-- Ödünç geçmişi olan nüsha silinemez. (NO ACTION: varsayılan davranış)
ALTER TABLE loan
  ADD CONSTRAINT fk_loan_copy
  FOREIGN KEY (copy_id) REFERENCES book_copy (copy_id)
  ON DELETE NO ACTION;
