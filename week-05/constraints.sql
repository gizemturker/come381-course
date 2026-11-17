-- COME 381 - Odev 2 / Bolum A: Butunluk Kisitlari (Integrity Constraints)
-- Bu betik sql/schema.sql calistirildiktan sonra calisir.

-- ============================================================================
-- 1. NOT NULL KISITLARI
-- ============================================================================

-- Her egitmenin adi, e-postasi, uzmanlik alani, sehri, saatlik ucreti ve ise baslama tarihi zorunludur.
ALTER TABLE instructor
    ALTER COLUMN full_name SET NOT NULL,
    ALTER COLUMN email SET NOT NULL,
    ALTER COLUMN specialty SET NOT NULL,
    ALTER COLUMN city SET NOT NULL,
    ALTER COLUMN hourly_rate SET NOT NULL,
    ALTER COLUMN hire_date SET NOT NULL;

-- Her salonun adi, bulundugu kat ve maksimum kapasitesi zorunludur.
ALTER TABLE room
    ALTER COLUMN room_name SET NOT NULL,
    ALTER COLUMN floor_no SET NOT NULL,
    ALTER COLUMN max_capacity SET NOT NULL;

-- Her kursiyerin adi, e-postasi, sehri, uyelik tipi ve kayit tarihi zorunludur.
ALTER TABLE student
    ALTER COLUMN full_name SET NOT NULL,
    ALTER COLUMN email SET NOT NULL,
    ALTER COLUMN city SET NOT NULL,
    ALTER COLUMN membership_level SET NOT NULL,
    ALTER COLUMN registered_at SET NOT NULL;

-- Her atolyenin basligi, kategorisi, egitmeni, baslangic/bitis tarihleri, kontenjani ve ucreti zorunludur (room_id cevrimici atolyeler ve SET NULL politikasi icin bos kalabilir).
ALTER TABLE workshop
    ALTER COLUMN title SET NOT NULL,
    ALTER COLUMN category SET NOT NULL,
    ALTER COLUMN instructor_id SET NOT NULL,
    ALTER COLUMN start_date SET NOT NULL,
    ALTER COLUMN end_date SET NOT NULL,
    ALTER COLUMN quota SET NOT NULL,
    ALTER COLUMN fee SET NOT NULL;

-- Her atolye kaydinda kursiyer, atolye, kayit tarihi, katilim durumu ve odenen tutar zorunludur (rating degerlendirme henuz yapilmadiysa NULL kalabilir).
ALTER TABLE enrollment
    ALTER COLUMN student_id SET NOT NULL,
    ALTER COLUMN workshop_id SET NOT NULL,
    ALTER COLUMN enrolled_at SET NOT NULL,
    ALTER COLUMN attendance_status SET NOT NULL,
    ALTER COLUMN paid_amount SET NOT NULL;

-- ============================================================================
-- 2. UNIQUE KISITLARI
-- ============================================================================

-- Iki farkli egitmen ayni e-posta adresini kullanamaz.
ALTER TABLE instructor
    ADD CONSTRAINT uq_instructor_email
    UNIQUE (email);

-- Merkezdeki iki farkli atolye salonuna ayni ad verilemez.
ALTER TABLE room
    ADD CONSTRAINT uq_room_name
    UNIQUE (room_name);

-- Iki farkli kursiyer ayni e-posta adresiyle sisteme kaydolamaz.
ALTER TABLE student
    ADD CONSTRAINT uq_student_email
    UNIQUE (email);

-- Bir kursiyer ayni atolyeye birden fazla kez kaydolamaz (cok sutunlu UNIQUE).
ALTER TABLE enrollment
    ADD CONSTRAINT uq_enrollment_student_workshop
    UNIQUE (student_id, workshop_id);

-- ============================================================================
-- 3. CHECK KISITLARI
-- ============================================================================

-- Bir egitmenin saatlik ucreti sifirdan buyuk olmalidir.
ALTER TABLE instructor
    ADD CONSTRAINT chk_instructor_hourly_rate_positive
    CHECK (hourly_rate > 0);

-- Bir atolye salonunun maksimum kapasitesi sifirdan buyuk olmalidir.
ALTER TABLE room
    ADD CONSTRAINT chk_room_capacity_positive
    CHECK (max_capacity > 0);

-- Kursiyer uyelik tipi yalnizca izin verilen uc seviyeden biri ('standard', 'student', 'vip') olabilir.
ALTER TABLE student
    ADD CONSTRAINT chk_student_membership
    CHECK (membership_level IN ('standard', 'student', 'vip'));

-- Bir atolyenin kontenjani en az 1 olmalidir (sifir veya negatif olamaz).
ALTER TABLE workshop
    ADD CONSTRAINT chk_workshop_quota_positive
    CHECK (quota > 0);

-- Bir atolyenin katilim ucreti negatif olamaz (ucretsiz etkinlikler icin 0 olabilir).
ALTER TABLE workshop
    ADD CONSTRAINT chk_workshop_fee_nonnegative
    CHECK (fee >= 0);

-- Atolye kategorisi yalnizca merkezin faaliyet gosterdigi sanat dallarindan biri olabilir.
ALTER TABLE workshop
    ADD CONSTRAINT chk_workshop_category
    CHECK (category IN ('ceramics', 'painting', 'photography', 'music', 'theater'));

-- Bir atolye basladigi tarihten daha onceki bir tarihte bitemez (iki sutunu karsilastiran CHECK).
ALTER TABLE workshop
    ADD CONSTRAINT chk_workshop_date_order
    CHECK (end_date >= start_date);

-- Atolye kaydinin katilim durumu yalnizca tanimli dort durumdan biri olabilir.
ALTER TABLE enrollment
    ADD CONSTRAINT chk_enrollment_status
    CHECK (attendance_status IN ('registered', 'attended', 'completed', 'cancelled'));

-- Kursiyerin odedigi ucret negatif bir deger olamaz.
ALTER TABLE enrollment
    ADD CONSTRAINT chk_enrollment_paid_nonnegative
    CHECK (paid_amount >= 0);

-- Kursiyerin atolyeye verdigi puan 1 ile 5 arasinda olmalidir.
ALTER TABLE enrollment
    ADD CONSTRAINT chk_enrollment_rating_range
    CHECK (rating BETWEEN 1 AND 5);

-- ============================================================================
-- 4. ISIMLENDIRILMIS FOREIGN KEY VE ON DELETE POLITIKALARI
-- ============================================================================

-- Odev 1'de olusturulan varsayilan isimli foreign key'leri kaldirip anlamli isimlerle yeniden ekliyoruz.
ALTER TABLE workshop
    DROP CONSTRAINT IF EXISTS workshop_instructor_id_fkey,
    DROP CONSTRAINT IF EXISTS workshop_room_id_fkey;

ALTER TABLE enrollment
    DROP CONSTRAINT IF EXISTS enrollment_student_id_fkey,
    DROP CONSTRAINT IF EXISTS enrollment_workshop_id_fkey;

-- Aktif veya gecmis atolyesi bulunan bir egitmen, atolyeleri baska egitmene devredilmeden silinemez.
ALTER TABLE workshop
    ADD CONSTRAINT fk_workshop_instructor
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id)
    ON DELETE RESTRICT;

-- Bir salon kapatildiginda veya silindiginde atolyenin kendisi silinmez, yalnizca salon bilgisi bosaltilir (NULL olur).
ALTER TABLE workshop
    ADD CONSTRAINT fk_workshop_room
    FOREIGN KEY (room_id) REFERENCES room(room_id)
    ON DELETE SET NULL;

-- Bir kursiyer sistemden silindiginde ona ait atolye kayitlari da otomatik olarak silinir.
ALTER TABLE enrollment
    ADD CONSTRAINT fk_enrollment_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON DELETE CASCADE;

-- Kayitli kursiyeri bulunan bir atolye dogrudan silinemez; once kayitlar yonetilmelidir (varsayilan NO ACTION davranisi).
ALTER TABLE enrollment
    ADD CONSTRAINT fk_enrollment_workshop
    FOREIGN KEY (workshop_id) REFERENCES workshop(workshop_id)
    ON DELETE NO ACTION;
