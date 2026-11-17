# Yapay Zeka Kullanım Günlüğü (`AI_LOG.md`)

## Ödev 1

- **Kullanım Amacı:** Kültür ve Sanat Merkezi Atölye Yönetim Sistemi senaryosundaki varlıkların (`instructor`, `room`, `student`, `workshop`, `enrollment`) Mermaid `erDiagram` sözdizimiyle görselleştirilmesi ve `sql/schema.sql` içerisindeki `GENERATED ALWAYS AS IDENTITY` tanımlamalarının kontrol edilmesi için kullanıldı.
- **Doğrulama:** Oluşturulan şema temiz bir PostgreSQL 18 veritabanında (`come381`) çalıştırılarak tüm tabloların ve anahtarların hatasız oluştuğu doğrulandı.

---

## Ödev 2

### 1. Bölüm E — D6 (Division / Bölme) Sorgusu Denemesi

#### Kullanılan Prompt

```text
PostgreSQL veritabanımda şu üç tablo var:
- student(student_id, full_name, email, city, membership_level, registered_at)
- workshop(workshop_id, title, category, instructor_id, room_id, start_date, end_date, quota, fee)
- enrollment(enrollment_id, student_id, workshop_id, enrolled_at, attendance_status, paid_amount, rating)

'ceramics' kategorisindeki TÜM atölyelere kaydolmuş kursiyerlerin student_id ve full_name bilgilerini döndüren bir SQL sorgusu yazar mısın? GROUP BY ve HAVING COUNT kullanarak yaz.
```

#### Yapay Zekanın Ürettiği İlk Sorgu (Hatalı / Yanıltılabilir `COUNT` Yaklaşımı)

Yapay zeka ilk yanıtta kursiyerin katıldığı toplam atölye sayısını seramik kategorisindeki toplam atölye sayısıyla karşılaştıran, ancak `WHERE w.category = 'ceramics'` filtresini dış sorguda unutup yalnızca `HAVING` alt sorgusunda kullanan (veya `COUNT(*)` kullanan) şu sorguyu verdi:

```sql
SELECT s.student_id, s.full_name
FROM student s
JOIN enrollment e ON e.student_id = s.student_id
GROUP BY s.student_id, s.full_name
HAVING COUNT(e.workshop_id) >= (
    SELECT COUNT(*)
    FROM workshop
    WHERE category = 'ceramics'
)
ORDER BY s.student_id;
```

#### Kendi Verimizde (`seed.sql`) Karşılaştırma ve Hatanın Gösterimi

`seed.sql` dosyasına bu tür `COUNT` tabanlı division sorgularını yanıltmak için özel olarak **`Zeynep Celik (student_id = 3)`** verisini ekledik:
- Sistemde `'ceramics'` kategorisinde toplam **3 atölye** vardır (`workshop_id = 1, 2, 3`).
- `Ayse Kaya (id = 1)` ve `Mert Demir (id = 2)` bu 3 seramik atölyesinin tamamına katılmıştır.
- `Zeynep Celik (id = 3)` ise 3 seramik atölyesinin **yalnızca 2'sine** (`workshop_id = 1, 2`) katılmış, 3. seramik atölyesine (`workshop_id = 3`) **katılmamıştır**; fakat bunun yanında `'painting'` (`workshop_id = 4`) ve `'photography'` (`workshop_id = 5`) kategorilerinden 2 atölyeye daha kaydolduğu için toplam 4 kaydı vardır.

**Yapay Zekanın Sorgusunun Çıktısı (Yanlış — `Zeynep Celik` de listeleniyor):**

```text
 student_id |  full_name   
------------+--------------
          1 | Ayse Kaya
          2 | Mert Demir
          3 | Zeynep Celik
(3 rows)
```

**Kendi `algebra.sql` Sorgumuzun (İç İçe İki `NOT EXISTS`) Çıktısı (Doğru):**

```text
 student_id | full_name  
------------+------------
          1 | Ayse Kaya
          2 | Mert Demir
(2 rows)
```

#### Hatanın Nedeni ve Düzeltilmesi

1. **Kategori Dışı Kayıtların Sayıma Girmesi:** Yukarıdaki `GROUP BY ... HAVING COUNT(e.workshop_id)` sorgusu, kursiyerin yalnızca `'ceramics'` atölyelerini değil tüm kategorilerdeki atölye kayıtlarını saymaktadır. `Zeynep Celik` 2 seramik + 2 diğer kategori olmak üzere 4 kayda sahip olduğu için `4 >= 3` koşulunu sağlamakta ve yanlışlıkla sonuç kümesine girmektedir.
2. **Mükerrer Kayıt Riski (`COUNT` vs `COUNT(DISTINCT ...)`):** Ayrıca `enrollment` tablosunda `(student_id, workshop_id)` üzerinde `UNIQUE` kısıtı olmasaydı, aynı seramik atölyesine iki kez kaydolan ve toplamda 3 satırı bulunan bir kursiyer `WHERE w.category = 'ceramics'` eklense bile `COUNT(e.workshop_id) = 3` koşulunu yanlışlıkla sağlayacaktı.
3. **Doğru Çözüm:** `algebra.sql` içerisinde kullandığımız iç içe iki `NOT EXISTS` yapısı ("katılmadığı hiçbir seramik atölyesi bulunmayan kursiyerler") veya `WHERE w.category = 'ceramics'` filtresiyle birlikte `HAVING COUNT(DISTINCT e.workshop_id) = (SELECT COUNT(*) FROM workshop WHERE category = 'ceramics')` kullanımı `Zeynep Celik` satırını doğru biçimde elemektedir.

---

### 2. Ödevin Diğer Bölümlerinde Yapay Zeka Kullanımı

- **Bölüm A & B (`constraints.sql`, `violations.sql`):** Kısıt isimlendirme kalıplarının (`chk_`, `uq_`, `fk_`) kontrolü ve her kısıt için sınır değer / `NULL` test senaryolarının kurgulanmasında yardımcı olarak kullanıldı. Tüm testler yerel PostgreSQL 18 (`psql`) üzerinde çalıştırılarak gerçek `SQLSTATE` çıktıları (`violations_output.txt`) doğrudan `psql`'den alındı.
- **Bölüm C & D (`on_delete.md`, `algebra.md`, `algebra.sql`):** İlişkisel cebir ifadelerinin ($\sigma, \pi, \bowtie, \cup, -, \rho, \div$) LaTeX gösterimlerinin düzenlenmesi ve PostgreSQL `RESTRICT` / `NO ACTION` davranış farkının dokümantasyon üzerinden doğrulanması için kullanıldı.
