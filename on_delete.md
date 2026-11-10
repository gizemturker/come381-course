# Ödev 2 — ON DELETE politikaları

| Foreign key | Ebeveyn | Çocuk | Seçim | Neden |
|---|---|---|---|---|
| workshop.instructor_id | instructor | workshop | RESTRICT (varsayılan NO ACTION) | Atölyesi olan eğitmen yanlışlıkla silinmesin |
| registration.customer_id | customer | registration | CASCADE | Müşteri silinince ona ait kayıtlar temizlensin |
| registration.workshop_id | workshop | registration | CASCADE | Atölye silinince ona ait kayıtlar temizlensin |

`NO ACTION` ve `RESTRICT` çoğu basit durumda benzer sonuç verir; ertelenebilir kısıtlar açısından farkları vardır. Aşağıdaki SQL, `schema.sql` sonrasında uygulanabilir:

```sql
ALTER TABLE registration DROP CONSTRAINT registration_customer_id_fkey;
ALTER TABLE registration ADD CONSTRAINT registration_customer_id_fkey
 FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;
ALTER TABLE registration DROP CONSTRAINT registration_workshop_id_fkey;
ALTER TABLE registration ADD CONSTRAINT registration_workshop_id_fkey
 FOREIGN KEY (workshop_id) REFERENCES workshop(workshop_id) ON DELETE CASCADE;
```

## Güvenli deney
```sql
BEGIN;
DELETE FROM customer WHERE customer_id=1;
SELECT * FROM registration WHERE customer_id=1;
ROLLBACK;
```

Silme deneyinden önce yukarıdaki CASCADE değişikliklerini uygulayın. `ROLLBACK` verileri geri alır.
