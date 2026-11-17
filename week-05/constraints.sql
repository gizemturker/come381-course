-- Bolum A: Butunluk Kisitlari (constraints.sql)
-- sql/schema.sql calistirildiktan sonra calistirilir.

-- 1. NOT NULL Kisitlari

-- Hayvan sahibinin ad, telefon, e-posta, ilce ve kayit tarihi bilgileri bos birakilamaz.
ALTER TABLE pet_owner
    ALTER COLUMN full_name SET NOT NULL,
    ALTER COLUMN phone SET NOT NULL,
    ALTER COLUMN email SET NOT NULL,
    ALTER COLUMN district SET NOT NULL,
    ALTER COLUMN registered_date SET NOT NULL;

-- Veteriner hekimin ad, diploma/ruhsat numarasi, uzmanlik alani, muayene ucreti ve calisma durumu zorunludur.
ALTER TABLE veterinarian
    ALTER COLUMN full_name SET NOT NULL,
    ALTER COLUMN license_no SET NOT NULL,
    ALTER COLUMN specialization SET NOT NULL,
    ALTER COLUMN consultation_fee SET NOT NULL,
    ALTER COLUMN employment_status SET NOT NULL;

-- Evcil hayvanin sahibi, adi, turu, dogum yili ve kilosu zorunludur (primary_vet_id SET NULL icin bos kalabilir).
ALTER TABLE pet
    ALTER COLUMN owner_id SET NOT NULL,
    ALTER COLUMN pet_name SET NOT NULL,
    ALTER COLUMN species SET NOT NULL,
    ALTER COLUMN birth_year SET NOT NULL,
    ALTER COLUMN weight_kg SET NOT NULL;

-- Her asi/tedavi taniminin kodu, adi, kategorisi, uygun kilo araligi ve standart ucreti zorunludur.
ALTER TABLE treatment
    ALTER COLUMN treatment_code SET NOT NULL,
    ALTER COLUMN treatment_name SET NOT NULL,
    ALTER COLUMN treatment_type SET NOT NULL,
    ALTER COLUMN min_weight_kg SET NOT NULL,
    ALTER COLUMN max_weight_kg SET NOT NULL,
    ALTER COLUMN standard_cost SET NOT NULL;

-- Her tedavi kaydinda hayvan, islem, hekim, ziyaret tarihi ve alinan ucret zorunludur (next_due_date ve follow_up_score NULL olabilir).
ALTER TABLE pet_treatment
    ALTER COLUMN pet_id SET NOT NULL,
    ALTER COLUMN treatment_id SET NOT NULL,
    ALTER COLUMN vet_id SET NOT NULL,
    ALTER COLUMN visit_date SET NOT NULL,
    ALTER COLUMN charged_amount SET NOT NULL;

-- 2. UNIQUE Kisitlari

-- Ayni e-posta adresiyle birden fazla hayvan sahibi kaydedilemez.
ALTER TABLE pet_owner
    ADD CONSTRAINT uq_pet_owner_email
    UNIQUE (email);

-- Her veteriner hekimin oda sicil/ruhsat numarasi benzersiz olmalidir.
ALTER TABLE veterinarian
    ADD CONSTRAINT uq_veterinarian_license
    UNIQUE (license_no);

-- Katalogdaki her tibbi islem ve asinin protokol kodu benzersiz olmalidir.
ALTER TABLE treatment
    ADD CONSTRAINT uq_treatment_code
    UNIQUE (treatment_code);

-- Ayni evcil hayvana ayni asi/tedavi paketi mukerrer olarak kaydedilemez (cok sutunlu UNIQUE).
ALTER TABLE pet_treatment
    ADD CONSTRAINT uq_pet_treatment_pet_treatment
    UNIQUE (pet_id, treatment_id);

-- 3. CHECK Kisitlari

-- Veteriner hekimin muayene ucreti sifirdan buyuk olmalidir.
ALTER TABLE veterinarian
    ADD CONSTRAINT chk_vet_fee_positive
    CHECK (consultation_fee > 0);

-- Veteriner hekimin calisma durumu yalnizca tanimli uc degerden biri olabilir.
ALTER TABLE veterinarian
    ADD CONSTRAINT chk_vet_status
    CHECK (employment_status IN ('active', 'on_leave', 'part_time'));

-- Klinige kaydedilen hayvanin turu yalnizca kedi, kopek, kus veya tavsan olabilir.
ALTER TABLE pet
    ADD CONSTRAINT chk_pet_species
    CHECK (species IN ('cat', 'dog', 'bird', 'rabbit'));

-- Evcil hayvanin agirligi 0'dan buyuk ve en fazla 120 kg olmalidir.
ALTER TABLE pet
    ADD CONSTRAINT chk_pet_weight_range
    CHECK (weight_kg > 0 AND weight_kg <= 120);

-- Tibbi islemin kategorisi yalnizca izin verilen bes tedavi grubundan biri olabilir.
ALTER TABLE treatment
    ADD CONSTRAINT chk_treatment_type
    CHECK (treatment_type IN ('core_vaccine', 'parasite', 'checkup', 'dental', 'surgery'));

-- Bir tedavinin maksimum uygun agirligi minimum uygun agirligindan kucuk olamaz (iki sutunlu CHECK).
ALTER TABLE treatment
    ADD CONSTRAINT chk_treatment_weight_order
    CHECK (max_weight_kg >= min_weight_kg);

-- Bir tedavinin standart katalog ucreti negatif olamaz.
ALTER TABLE treatment
    ADD CONSTRAINT chk_treatment_cost_nonnegative
    CHECK (standard_cost >= 0);

-- Bir sonraki kontrol/hatirlatma tarihi islem tarihinden once olamaz (iki sutunlu CHECK).
ALTER TABLE pet_treatment
    ADD CONSTRAINT chk_pet_treatment_dates
    CHECK (next_due_date >= visit_date);

-- Hayvan sahibinden tahsil edilen tedavi tutari negatif olamaz.
ALTER TABLE pet_treatment
    ADD CONSTRAINT chk_pet_treatment_charged_nonnegative
    CHECK (charged_amount >= 0);

-- Tedavi sonrasi iyilesme takip puani 1 ile 10 arasinda olmalidir.
ALTER TABLE pet_treatment
    ADD CONSTRAINT chk_pet_treatment_score_range
    CHECK (follow_up_score BETWEEN 1 AND 10);

-- 4. Isimlendirilmis FOREIGN KEY ve ON DELETE Politikalari

ALTER TABLE pet
    DROP CONSTRAINT IF EXISTS pet_owner_id_fkey,
    DROP CONSTRAINT IF EXISTS pet_primary_vet_id_fkey;

ALTER TABLE pet_treatment
    DROP CONSTRAINT IF EXISTS pet_treatment_pet_id_fkey,
    DROP CONSTRAINT IF EXISTS pet_treatment_treatment_id_fkey,
    DROP CONSTRAINT IF EXISTS pet_treatment_vet_id_fkey;

-- Bir hayvan sahibi sistemden silindiginde ona ait evcil hayvan kayitlari da otomatik silinir.
ALTER TABLE pet
    ADD CONSTRAINT fk_pet_owner
    FOREIGN KEY (owner_id) REFERENCES pet_owner(owner_id)
    ON DELETE CASCADE;

-- Sorumlu birincil veteriner hekim sistemden cikarildiginda hayvanin kaydi silinmez, yalnizca primary_vet_id NULL yapilir.
ALTER TABLE pet
    ADD CONSTRAINT fk_pet_primary_vet
    FOREIGN KEY (primary_vet_id) REFERENCES veterinarian(vet_id)
    ON DELETE SET NULL;

-- Bir evcil hayvan kaydi silindiginde o hayvana ait tedavi gecmisi de birlikte silinir.
ALTER TABLE pet_treatment
    ADD CONSTRAINT fk_pet_treatment_pet
    FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
    ON DELETE CASCADE;

-- Gecmiste uygulanmis bir asi/tedavi turu katalogdan silinemez (RESTRICT).
ALTER TABLE pet_treatment
    ADD CONSTRAINT fk_pet_treatment_treatment
    FOREIGN KEY (treatment_id) REFERENCES treatment(treatment_id)
    ON DELETE RESTRICT;

-- Gecmiste islem yapmis bir veteriner hekim, tedavi kayitlari dururken silinemez (NO ACTION).
ALTER TABLE pet_treatment
    ADD CONSTRAINT fk_pet_treatment_vet
    FOREIGN KEY (vet_id) REFERENCES veterinarian(vet_id)
    ON DELETE NO ACTION;
