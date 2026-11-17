# Bölüm C: Silme Politikaları (`on_delete.md`)

Veteriner Kliniği Evcil Hayvan ve Aşı/Tedavi Takip Sistemi şemasındaki beş yabancı anahtar (`FOREIGN KEY`) için belirlenen `ON DELETE` kuralları ve gerekçeleri aşağıda tablolaştırılmıştır.

| Foreign key | Ebeveyn → çocuk | Seçimin | Neden | Diğer seçenek neden olmadı |
|---|---|---|---|---|
| `fk_pet_owner` | `pet_owner` → `pet` | `CASCADE` | Bir hayvan sahibi kaydını klinikten tamamen sildirdiğinde, ona bağlı evcil hayvan profillerinin de sistemden kaldırılması gerekir. | `RESTRICT` sahibini silmeyi engellerdi; `SET NULL` ise sahipsiz (`owner_id` sütunu `NOT NULL`) hayvan kaydı bırakamayacağından hata verirdi. |
| `fk_pet_primary_vet` | `veterinarian` → `pet` | `SET NULL` | Birincil sorumlu veteriner hekim klinikten ayrıldığında hayvanın profili silinmemeli, yalnızca sorumlu hekim alanı boşaltılarak (`NULL`) yeni hekim atanana kadar beklenmelidir. | `CASCADE` hekim ayrıldığında baktığı tüm hayvanları sileceği için büyük veri kaybı yaratırdı; `RESTRICT` ise hekim kaydını silmeyi gereksiz yere kilitlerdi. |
| `fk_pet_treatment_pet` | `pet` → `pet_treatment` | `CASCADE` | Bir evcil hayvan kaydı sistemden silindiğinde, o hayvana ait geçmiş uygulama satırlarının tek başına kalmasının anlamı yoktur. | `RESTRICT` hayvan kaydının silinmesini imkânsız hale getirirdi; `SET NULL` ise hangi hayvana işlem yapıldığı bilgisini bozardı. |
| `fk_pet_treatment_treatment` | `treatment` → `pet_treatment` | `RESTRICT` | Klinikte daha önce hayvanlara uygulanmış bir aşı veya tıbbi işlem tanımının katalogdan yanlışlıkla silinmesi tıbbi geçmişi bozar. | `CASCADE` seçilseydi katalogdan bir aşı silindiğinde o aşının yapıldığı tüm klinik kayıtları da silinirdi. |
| `fk_pet_treatment_vet` | `veterinarian` → `pet_treatment` | `NO ACTION` | Geçmişte tıbbi işlem gerçekleştirmiş bir hekim, yaptığı işlemlerin sorumluluk kaydı dururken doğrudan silinememelidir. | `CASCADE` hekimin yaptığı tüm tıbbi işlem kayıtlarını yok ederdi; `SET NULL` ise işlemi hangi hekimin yaptığı bilgisini kaybettirirdi. |

## `CASCADE` Davranışı Kanıtı (`fk_pet_treatment_pet`)

`seed.sql` çalıştırıldıktan sonra `pet` tablosunda 8 hayvan bulunmakta ve `pet_id = 6` (`Pasa`) için `pet_treatment` tablosunda 1 adet işlem kaydı yer almaktadır. `pet_id = 6` silindiğinde `fk_pet_treatment_pet` (`ON DELETE CASCADE`) nedeniyle bağlı işlem kaydı da otomatik olarak silinir:

```sql
SELECT count(*) AS pet_count_before FROM pet;
SELECT count(*) AS treatment_records_before FROM pet_treatment WHERE pet_id = 6;

DELETE FROM pet WHERE pet_id = 6;

SELECT count(*) AS pet_count_after FROM pet;
SELECT count(*) AS treatment_records_after FROM pet_treatment WHERE pet_id = 6;
```

Çıktı:

```text
 pet_count_before 
------------------
                8
(1 row)

 treatment_records_before 
--------------------------
                        1
(1 row)

DELETE 1
 pet_count_after 
-----------------
               7
(1 row)

 treatment_records_after 
-------------------------
                       0
(1 row)
```

## `RESTRICT` ile `NO ACTION` Arasındaki Fark

`RESTRICT` silme veya güncelleme ifadesi çalıştığı anda referans ihlalini hemen kontrol eder ve kısıtın ertelenmesine (`DEFERRABLE`) izin vermez; `NO ACTION` ise kısıt `DEFERRABLE INITIALLY DEFERRED` olarak tanımlandığında denetimin transaction sonuna (`COMMIT` aşamasına) bırakılmasına olanak sağlar.
