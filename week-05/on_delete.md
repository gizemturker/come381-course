# Bölüm C: Yabancı Anahtar Silme Politikaları (`ON DELETE`)

Bu belgede, Kültür ve Sanat Merkezi Atölye Yönetim Sistemi şemasındaki tüm yabancı anahtarlar (`FOREIGN KEY`) için seçilen `ON DELETE` davranışları, iş kurallarına dayalı gerekçeleri ve `CASCADE` davranışının `psql` üzerindeki kanıtı yer almaktadır.

## 1. Yabancı Anahtar Silme Politikaları Tablosu

| Foreign key | Ebeveyn → çocuk | Seçimin | Neden | Diğer seçenek neden olmadı |
|---|---|---|---|---|
| `fk_enrollment_student` | `student` → `enrollment` | `CASCADE` | Bir kursiyer kişisel verilerinin silinmesini talep ettiğinde veya üyeliği tamamen kaldırıldığında, o kursiyere bağlı atölye kayıt satırlarının tek başına tutulmasının iş açısından anlamı kalmaz. | `RESTRICT` kursiyeri silmeyi imkânsız kılardı; `SET NULL` ise `enrollment.student_id` sütunu `NOT NULL` olduğu için çalışmaz ve sahipsiz kayıt bırakırdı. |
| `fk_workshop_instructor` | `instructor` → `workshop` | `RESTRICT` | Aktif veya geçmişte atölye vermiş bir eğitmenin yanlışlıkla silinmesi, o eğitmene bağlı tüm atölyelerin bilgisini bozar; önce atölyeler başka bir eğitmene devredilmelidir. | `CASCADE` seçilseydi bir eğitmen silindiğinde tüm atölyeleri de zincirleme silinirdi; `SET NULL` ise `workshop.instructor_id` sütunu zorunlu (`NOT NULL`) olduğu için hata verirdi. |
| `fk_workshop_room` | `room` → `workshop` | `SET NULL` | Fiziksel bir stüdyo/salon tadilata girdiğinde veya kapatılıp sistemden silindiğinde atölyenin kendisi iptal edilmemeli, yalnızca salon ataması boşaltılıp (`NULL`) yeni salon atanana kadar korunmalıdır. | `CASCADE` salon silinince o salondaki tüm atölyeleri de sileceği için veri kaybına yol açardı; `RESTRICT` ise eski bir salon kaydını kaldırmayı gereksiz yere engellerdi. |
| `fk_enrollment_workshop` | `workshop` → `enrollment` | `NO ACTION` | İçinde kayıtlı kursiyerleri ve ödeme bilgileri bulunan bir atölyenin doğrudan silinmesi finansal ve operasyonel veri kaybına yol açar; önce kayıtlar iptal/iade edilmelidir. | `CASCADE` ödenmiş kayıt geçmişini sessizce yok ederdi; `SET NULL` ise hangi atölyeye kayıt yapıldığı bilgisini ortadan kaldırırdı. |

---

## 2. `ON DELETE CASCADE` Kanıtı (`fk_enrollment_student`)

`seed.sql` verisi yüklendikten sonra sistemde toplam **8 kursiyer (`student`)** vardır ve `student_id = 6` (`Canan Yilmaz`) olan kursiyerin `enrollment` tablosunda **2 adet** atölye kaydı bulunmaktadır. Bu kursiyer `student` tablosundan silindiğinde `fk_enrollment_student` üzerindeki `ON DELETE CASCADE` kuralı devreye girerek ilgili 2 kayıt satırını otomatik olarak silmektedir:

### Çalıştırılan Komutlar

```sql
SELECT count(*) AS student_count_before FROM student;
SELECT count(*) AS enrollment_count_before FROM enrollment WHERE student_id = 6;

DELETE FROM student WHERE student_id = 6;

SELECT count(*) AS student_count_after FROM student;
SELECT count(*) AS enrollment_count_after FROM enrollment WHERE student_id = 6;
```

### `psql` Çıktısı

```text
 student_count_before 
----------------------
                    8
(1 row)

 enrollment_count_before 
-------------------------
                       2
(1 row)

DELETE 1
 student_count_after 
---------------------
                   7
(1 row)

 enrollment_count_after 
------------------------
                      0
(1 row)
```

---

## 3. `RESTRICT` ile `NO ACTION` Arasındaki Fark

`RESTRICT`, silme veya güncelleme komutu çalıştırıldığı anda referans ihlalini derhal denetler ve kısıtın işlem sonuna ertelenmesine (`DEFERRABLE`) izin vermezken; PostgreSQL'in varsayılanı olan `NO ACTION`, kısıt `DEFERRABLE INITIALLY DEFERRED` olarak tanımlandığında referans denetiminin transaction (`COMMIT`) sonuna kadar ertelenmesine olanak tanır (ayrıca PostgreSQL'de `RESTRICT` ihlali `23001 restrict_violation`, `NO ACTION` ihlali ise `23503 foreign_key_violation` hata kodunu üretir).
