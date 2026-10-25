-- Her öğrencinin e-posta adresi benzersiz olmalıdır.
ALTER TABLE student
    ADD CONSTRAINT uq_student_email UNIQUE (email);

-- Bir öğrenci aynı staja birden fazla başvuru yapamaz.
ALTER TABLE application
    ADD CONSTRAINT uq_student_internship UNIQUE (student_id, internship_id);

-- Bir şirket aynı başlıkla iki staj ilanı açamaz.
ALTER TABLE internship
    ADD CONSTRAINT uq_company_internship_title UNIQUE (company_id, title);

-- Belirtilen staj kapasitesi pozitif olmalıdır; NULL değerine izin verilir.
ALTER TABLE internship
    ADD CONSTRAINT chk_internship_capacity CHECK (capacity > 0);

-- Stajın bitiş tarihi başlangıç tarihinden önce olamaz.
ALTER TABLE internship
    ADD CONSTRAINT chk_internship_dates CHECK (end_date >= start_date);

-- Başvuru durumu izin verilen değerlerden biri olmalıdır.
ALTER TABLE application
    ADD CONSTRAINT chk_application_status
    CHECK (status IN ('submitted', 'reviewing', 'accepted', 'rejected'));