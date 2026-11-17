# Yapay Zeka Kullanım Kaydı (`AI_LOG.md`)

## Ödev 1

- Veteriner Kliniği Evcil Hayvan ve Aşı/Tedavi Takip Sistemi senaryosundaki 5 tablonun (`pet_owner`, `veterinarian`, `pet`, `treatment`, `pet_treatment`) Mermaid `erDiagram` formatında çizilmesi ve `sql/schema.sql` içerisindeki veri tiplerinin kontrolü için yapay zekadan yararlanıldı.

---

## Ödev 2

### Bölüm E — D6 (Division) Sorgusu Denemesi

#### 1. Gönderilen Prompt

```text
PostgreSQL'de şu tablolarım var:
pet(pet_id, owner_id, primary_vet_id, pet_name, species, birth_year, weight_kg)
treatment(treatment_id, treatment_code, treatment_name, treatment_type, min_weight_kg, max_weight_kg, standard_cost)
pet_treatment(record_id, pet_id, treatment_id, vet_id, visit_date, next_due_date, charged_amount, follow_up_score)

treatment_type = 'core_vaccine' olan TÜM aşıları tamamlanmış evcil hayvanların pet_id ve pet_name alanlarını bulan SQL sorgusunu GROUP BY ve HAVING COUNT kullanarak yazar mısın?
```

#### 2. Yapay Zekanın Verdiği Sorgu

Yapay zeka `HAVING COUNT` içinde `'core_vaccine'` sayısını kontrol eden fakat ana `JOIN` sorgusunda `WHERE t.treatment_type = 'core_vaccine'` koşulunu unutan şu sorguyu üretti:

```sql
SELECT p.pet_id, p.pet_name
FROM pet p
JOIN pet_treatment pt ON pt.pet_id = p.pet_id
GROUP BY p.pet_id, p.pet_name
HAVING COUNT(pt.treatment_id) >= (
    SELECT COUNT(*)
    FROM treatment
    WHERE treatment_type = 'core_vaccine'
)
ORDER BY p.pet_id;
```

#### 3. Kendi Verimizde Çalıştırma ve Karşılaştırma

`seed.sql` verisinde `'core_vaccine'` tipinde 3 aşı (`treatment_id = 1, 2, 3`) bulunmaktadır.
- `Boncuk (pet_id = 1)` ve `Karamel (pet_id = 2)` bu 3 temel aşının tamamını almıştır.
- `Pamuk (pet_id = 3)` ise 3 temel aşıdan yalnızca 2'sini (`1` ve `2`) almış, 3. temel aşıyı (`3`) almamıştır; ancak `'parasite'` (`4`) ve `'dental'` (`5`) kategorilerinde 2 işlemi daha olduğu için toplamda 4 işlem kaydına sahiptir.

**Yapay Zeka Sorgusunun Sonucu (Hatalı — `Pamuk` da dönüyor):**

```text
 pet_id | pet_name 
--------+----------
      1 | Boncuk
      2 | Karamel
      3 | Pamuk
(3 rows)
```

**Kendi `algebra.sql` Sorgumuzun (İç İçe İki `NOT EXISTS`) Sonucu (Doğru):**

```text
 pet_id | pet_name 
--------+----------
      1 | Boncuk
      2 | Karamel
(2 rows)
```

#### 4. Hatanın Açıklaması

Yapay zekanın verdiği `GROUP BY ... HAVING COUNT(pt.treatment_id)` sorgusu, hayvanın yalnızca `'core_vaccine'` işlemlerini filtrelemeden tüm tedavi kayıtlarını saymaktadır. `Pamuk` 2 temel aşı + 2 farklı işlemle toplam 4 kayda ulaştığı için `4 >= 3` koşulunu geçmekte ve hatalı olarak tüm temel aşıları tamamlanmış gibi görünmektedir. `algebra.sql` dosyasında kullandığımız çift `NOT EXISTS` yaklaşımı ise her bir `'core_vaccine'` satırını tek tek kontrol ettiği için `Pamuk` kaydını doğru biçimde elemektedir.

---

### Diğer Bölümlerde Yapay Zeka Kullanımı

- `constraints.sql` ve `violations.sql` dosyalarında kısıt adlandırmalarının ve test senaryolarının kontrol edilmesi, `algebra.md` dosyasındaki ilişkisel cebir ifadelerinin biçimlendirilmesi için kullanıldı.
