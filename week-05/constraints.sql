-- Kategori adi bos birakilamaz.
ALTER TABLE category
    ALTER COLUMN name SET NOT NULL;

-- Uyenin adi bos birakilamaz.
ALTER TABLE member
    ALTER COLUMN full_name SET NOT NULL;

-- Uyenin e-posta adresi bos birakilamaz.
ALTER TABLE member
    ALTER COLUMN email SET NOT NULL;

-- Uyenin durumu bos birakilamaz.
ALTER TABLE member
    ALTER COLUMN status SET NOT NULL;

-- Her etkinlik bir kategoriye ait olmalidir.
ALTER TABLE event
    ALTER COLUMN category_id SET NOT NULL;

-- Etkinlik basligi bos birakilamaz.
ALTER TABLE event
    ALTER COLUMN title SET NOT NULL;

-- Etkinligin baslangic tarihi bos birakilamaz.
ALTER TABLE event
    ALTER COLUMN start_date SET NOT NULL;

-- Etkinligin bitis tarihi bos birakilamaz.
ALTER TABLE event
    ALTER COLUMN end_date SET NOT NULL;

-- Etkinligin kapasitesi bos birakilamaz.
ALTER TABLE event
    ALTER COLUMN capacity SET NOT NULL;

-- Her kayit bir uyeye ait olmalidir.
ALTER TABLE event_registration
    ALTER COLUMN member_id SET NOT NULL;

-- Her kayit bir etkinlige ait olmalidir.
ALTER TABLE event_registration
    ALTER COLUMN event_id SET NOT NULL;

-- Kayit zamani bos birakilamaz.
ALTER TABLE event_registration
    ALTER COLUMN registered_at SET NOT NULL;

-- Ayni e-posta adresi iki farkli uye icin kullanilamaz.
ALTER TABLE member
    ADD CONSTRAINT uq_member_email
    UNIQUE (email);

-- Ayni kategori adi iki kez kullanilamaz.
ALTER TABLE category
    ADD CONSTRAINT uq_category_name
    UNIQUE (name);

-- Bir uye ayni etkinlige yalnizca bir kez kaydolabilir.
ALTER TABLE event_registration
    ADD CONSTRAINT uq_registration_member_event
    UNIQUE (member_id, event_id);

-- Etkinlik kapasitesi sifirdan buyuk olmalidir.
ALTER TABLE event
    ADD CONSTRAINT chk_event_capacity_positive
    CHECK (capacity > 0);

-- Uye durumu yalnizca izin verilen degerlerden biri olabilir.
ALTER TABLE member
    ADD CONSTRAINT chk_member_status
    CHECK (status IN ('active', 'suspended', 'closed'));

-- Bir etkinlik basladigi gunden once bitemez.
ALTER TABLE event
    ADD CONSTRAINT chk_event_date_order
    CHECK (end_date >= start_date);

-- Puan verildiyse 1 ile 5 arasinda olmalidir; NULL puan verilmeyen kaydi temsil eder.
ALTER TABLE event_registration
    ADD CONSTRAINT chk_registration_rating
    CHECK (rating BETWEEN 1 AND 5);

-- Bir kategori, kendisine bagli etkinlik varken silinemez.
ALTER TABLE event
    DROP CONSTRAINT fk_event_category;

ALTER TABLE event
    ADD CONSTRAINT fk_event_category
    FOREIGN KEY (category_id)
    REFERENCES category(category_id)
    ON DELETE NO ACTION;

-- Bir uye silinirse ona ait etkinlik kayitlari da silinir.
ALTER TABLE event_registration
    DROP CONSTRAINT fk_registration_member;

ALTER TABLE event_registration
    ADD CONSTRAINT fk_registration_member
    FOREIGN KEY (member_id)
    REFERENCES member(member_id)
    ON DELETE CASCADE;

-- Bir etkinlik silinirse o etkinlige ait kayitlar da silinir.
ALTER TABLE event_registration
    DROP CONSTRAINT fk_registration_event;

ALTER TABLE event_registration
    ADD CONSTRAINT fk_registration_event
    FOREIGN KEY (event_id)
    REFERENCES event(event_id)
    ON DELETE CASCADE;
