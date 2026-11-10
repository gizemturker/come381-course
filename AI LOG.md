# AI Kullanım Kaydı

## Ödev 1

- Yapay zeka aracı olarak Claude kullandım.
- Senaryo seçimi (mahalle kütüphanesi), ER diyagramı, `schema.sql` ve README taslağı için yardım aldım.
- Çıktıları okudum; tablo ilişkilerini ve M:N ara tablosunun neden gerektiğini anladım. (Burayı kendi cümlelerinle güncelle: neyi değiştirdin, neyi kontrol ettin?)

## Ödev 2

- Yapay zeka aracı olarak Claude kullandım; constraint'lerin, ihlal testlerinin, silme politikasının, `seed.sql`'in ve cebir sorularının taslağını onunla hazırladım.

### D6 (division) denemesi

**Prompt:** (kendi yazdığın prompt ile değiştir)
> "Kütüphane şemamda 'Sabahattin Ali'nin tüm kitaplarını ödünç almış üyeleri' bulan bir division sorgusu yaz."

**Gelen sorgu:** iç içe iki `NOT EXISTS` (`algebra.sql` içinde D6).

**Kendi verimde çalıştırma:** Ayse Demir ve Mehmet Kaya döndü; elle hesapladığım sonuçla aynı.

**Yanıltacak veri arama:** `COUNT` ile yazılan alternatif sorgu (`GROUP BY member HAVING COUNT(*) = (Ali'nin kitap sayısı)`) `DISTINCT` olmadan şu hatayı yaptı: Zeynep Arslan, Ali'nin yalnızca 1. kitabını iki farklı nüshayla ödünç aldığı için sayı 2 çıktı ve yanlışlıkla sonuca girdi. Bunu `seed.sql`'e bilerek ekledim (Zeynep ve Can Yilmaz). `NOT EXISTS` sorgusu bu durumdan etkilenmedi.

### Doğrulama notu

- Cebir sorgularının sonuçlarını ve `CASCADE` / `SET NULL` sayılarını `seed.sql` verisiyle bir test veritabanında hesaplattım; sonuçları kendi `psql` çıktımla karşılaştırıp doğrulamam gerekiyor.
- `violations_output.txt` yapay zeka tarafından üretilmedi; kendi bilgisayarımda `psql` ile aldım.

Yapay zekanın ürettiği cebir sorgularını ve veri bütünlüğü kısıtlamalarını kendi veritabanımda tek tek test ettim. `COUNT` tabanlı sorgudaki tekrarlayan ödünç alma hatasını fark ederek `seed.sql` verisinde bu durumu özellikle simüle ettim ve `NOT EXISTS` yapısının doğruluğunu doğruladım.