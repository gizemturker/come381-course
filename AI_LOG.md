# AI Log

## Ödev 1

**Araç:** ChatGPT

**Kullanım amacı:** Ödev 1 için senaryo seçimi, ER diyagramının hazırlanması, PostgreSQL şemasının oluşturulması, README içeriğinin düzenlenmesi ve PostgreSQL kurulum/parola sorunlarının giderilmesi için kullanıldı.

**Prompt özeti:** "COME 381 Ödev 1'i yönergeye uygun şekilde adım adım tamamlamama yardım et. Event/club management senaryosu için Mermaid ER diyagramı ve PostgreSQL schema.sql hazırla, her adımı test ederek ilerleyelim."

**Kontrol ve değişiklik:** Üretilen ilk `docs/er.md` dosyası kopyalama sırasında kaçış karakterleri, HTML entity'leri ve bozuk Türkçe karakterler içeriyordu. Dosya silinip sade UTF-8 içerikle yeniden oluşturuldu ve `type docs\er.md` ile kontrol edildi. `sql/schema.sql` temiz `come381_test` veritabanında çalıştırıldı ve dört `CREATE TABLE` komutunun da hatasız tamamlandığı doğrulandı.

**Sonuç:** Yapay zeka çıktıları doğrudan kabul edilmedi; ER dosyası düzeltilip şema PostgreSQL üzerinde çalıştırılarak doğrulandı.

## Ödev 2

**Araç:** ChatGPT

**D6 promptu:** "PostgreSQL'de member, event, category ve event_registration tabloları için, Sports kategorisindeki bütün etkinliklere kayıt olmuş üyeleri döndüren SQL sorgusunu yaz."

**Yapay zekanın ilk verdiği sorgu:**

```sql
SELECT m.member_id, m.full_name
FROM member m
JOIN event_registration er ON er.member_id = m.member_id
GROUP BY m.member_id, m.full_name
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM event e
    JOIN category c ON c.category_id = e.category_id
    WHERE c.name = 'Sports'
);
```

**Test sonucu:**

```text
1 | Ada Yilmaz
2 | Bora Demir
3 | Ceren Kaya
```

**Kontrol:** Doğru D6 sonucu yalnızca Ada Yilmaz ve Ceren Kaya olmalıydı. Bora Demir üç kayda sahip olduğu için hatalı sorgu tarafından döndürüldü. Ancak Bora'nın üç kaydının yalnızca ikisi Sports kategorisinde, diğeri Arts kategorisindedir. Sorgu dış sorguda kategori ayrımı yapmadan üyenin tüm kayıtlarını sayıyor. Bu nedenle toplam kayıt sayısı eşleşse bile yanlış sonuç verebiliyor.

**Doğru yaklaşım:** D6 sorgusunda çift `NOT EXISTS` yöntemi kullanıldı. Bu yöntem her Sports etkinliği için üyenin bir kaydı olup olmadığını doğrudan kontrol eder ve kategori dışı kayıtların sayılması gibi `COUNT` tabanlı hatalardan kaçınır.

**Diğer yapay zeka kullanımı:** Ödev 2 boyunca constraint testleri, `ON DELETE` politikaları, seed verisi, ilişkisel cebir ifadeleri ve SQL doğrulamaları hazırlanırken ChatGPT kullanıldı. Üretilen dosyalar PostgreSQL üzerinde çalıştırılarak kontrol edildi.

## Ödev 3

**Araç:** ChatGPT

**Kullanım amacı:** Ödev 3 yönergesinin anlaşılması, altı SQL sorgusunun hazırlanması, NULL deneylerinin yorumlanması ve DML işlemlerinin test edilmesi için kullanıldı.

**Prompt özeti:** "Kampüs Kafe veritabanındaki customer, product, orders ve order_item tabloları için yönergede istenen altı sorguyu, iki NULL deneyini ve iki DML komutunu hazırla. Her işlemi PostgreSQL üzerinde test ederek sonuçları yorumlayalım."

**Kontrol ve değişiklik:** `kafe.sql` dosyasının ilk yüklemesinde Türkçe karakter kodlaması nedeniyle hata oluştu. İstemci kodlaması UTF8 olarak ayarlandıktan sonra veri başarıyla yüklendi. Tablolarda 8 müşteri, 8 ürün, 12 sipariş ve 25 sipariş kalemi bulundu. Altı SELECT sorgusu PostgreSQL üzerinde çalıştırıldı ve sonuçları `sorgular_cikti.txt` dosyasına kaydedildi. NULL deneylerinde COUNT(*) 8, COUNT(phone) 5; AVG(age) 20,83, SUM(age) / COUNT(*) ise 15 sonucunu verdi. DML deneyinde sıcak içeceklerin fiyatları işlem içerisinde geçici olarak 5 TL artırıldı. Var olmayan 999 numaralı ürünün eklenmesi foreign key hatası (23503) oluşturdu. ROLLBACK komutuyla bütün değişiklikler geri alındı ve fiyatların başlangıç değerlerinde kaldığı doğrulandı.

**Sonuç:** Yapay zekâ çıktıları doğrudan kabul edilmedi; sorgular ve işlemler PostgreSQL üzerinde çalıştırılarak sonuçları kontrol edildi.
