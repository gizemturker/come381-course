-- Ödev 2: schema.sql çalıştırıldıktan sonra uygulanır.
ALTER TABLE workshop
 ADD CONSTRAINT chk_workshop_capacity CHECK (capacity BETWEEN 1 AND 30),
 ADD CONSTRAINT chk_workshop_date_order CHECK (end_date >= start_date);
ALTER TABLE registration
 ADD CONSTRAINT chk_registration_date CHECK (registered_on >= DATE '2020-01-01');
-- NOT NULL, UNIQUE ve foreign key kuralları schema.sql içinde tanımlıdır.
