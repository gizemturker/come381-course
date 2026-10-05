# Ders Bilgileri

## Dersin amacı

Öğrencilere ilişkisel veritabanı sistemlerini tasarlama, gerçekleme ve işletme becerisi kazandırmak. Gereksinimden kavramsal modele, oradan normalleştirilmiş bir PostgreSQL şemasına ilerlersin; sorguları yazar ve doğrularsın; performans, eşzamanlılık, kurtarma ve güvenlik konularını deneylerle incelersin. Ders ayrıca yapay zeka araçlarının ürettiği SQL ve şema çıktılarını eleştirel biçimde denetleme becerisini hedefler. Dönem sonunda kendi veritabanın üzerinde çalışan, yapay zeka destekli bir uygulama (capstone) teslim edersin.

## Öğrenme çıktıları

Bu dersi tamamlayan öğrenci:

1. Veritabanı sistemlerinin temel kavramlarını ve mimarisini açıklar.
2. Bir gereksinim metninden ER/EER diyagramı üretir.
3. ER/EER modelini ilişkisel şemaya dönüştürür, anahtar ve bütünlük kısıtlarını tanımlar.
4. Fonksiyonel bağımlılıkları belirler, şemayı BCNF'e kadar normalleştirir ve her adımı gerekçelendirir.
5. İlişkisel cebir ifadelerini SQL'e çevirir.
6. PostgreSQL'de DDL, DML, birleştirme, alt sorgu, CTE, pencere fonksiyonu, view ve trigger yazar.
7. İndeks tasarlar, `EXPLAIN ANALYZE` ile sorgu planlarını okur, iyileştirmeyi ölçer.
8. Transaction, ACID ve izolasyon seviyelerini iki eşzamanlı oturumda gösterir, anomalileri yorumlar.
9. Yedekleme ve geri yükleme senaryosu uygular, WAL tabanlı kurtarma mantığını açıklar.
10. Rol ve yetki tasarlar, SQL injection risklerini test eder ve önlemlerini uygular.
11. Yapay zekanın ürettiği SQL ve şema çıktılarını doğrular, hatalarını bulur ve belgeler.
12. Git/GitHub ile sürüm kontrollü, tekrar üretilebilir bir veritabanı projesi yönetir.

## Ders yapısı

Haftada 2 saat ders ve 2 saat laboratuvar, 14 hafta. Laboratuvar dersin devamı olarak aynı hafta içinde uygulamadır.

## Değerlendirme

| Bileşen | Ağırlık | Ayrıntı |
|---|---|---|
| Vize | %30 | Veritabanı tasarım dosyası (%20, Hafta 8) ve savunma, 7 dakika (%10, Hafta 9) |
| Ödevler | %20 | 6 ödevin ortalaması. En düşük not atılır, kalan 5 ödevin ortalaması alınır |
| Final | %50 | Capstone teslimi (%35, Hafta 14) ve savunma, 10 dakika (%15) |

Yazılı sınav yok: inşa edersin, sonra savunursun. Hafta 1 ödevi notsuzdur, 6 notlu ödev Hafta 2'den başlar. Capstone önerisi ve ara kontrol de ödevler arasında yer alır. Ödev konuları ve rubrikler, her ödevle birlikte repoya eklenir.

## Kurallar

- Çalışmalar bireyseldir.
- Teslim zamanı, `main` dalındaki son commit'in zaman damgasıdır.
- Vize teslimi, GitHub repoya ek olarak 1 sayfalık imzalı bir raporla tamamlanır. Rapor, savunma günü elden teslim edilir ve repodaki son commit'in kodunu (hash) taşır.
- İşi dönem boyunca küçük ve anlamlı commit'lerle ilerlet. Tek dev commit ile gelen teslimde puan kırılır.
- Şifre, API anahtarı ve token hiçbir zaman repoya girmez.
- Geç teslim: her gün için puanın %10'u düşer, 3 günden sonra kabul edilmez.
- Savunmaya katılamayan öğrenci için tek bir telafi oturumu yapılır.

## Yapay zeka politikası

Yapay zeka araçları serbesttir ve teşvik edilir. Sen onun denetçisisin:

- Her teslimde `AI_LOG.md` bulunur: hangi aracı, hangi prompt ile, ne için kullandın, çıktıda ne buldun, neyi değiştirdin.
- `AI_LOG.md` içinde bulup düzelttiğin en az bir yapay zeka hatası olur. Bu bölüm puanlıdır.
- Savunmada kendi tasarım kararını açıklayamazsan o bölüm puan kaybeder.

## İletişim

- E-posta: gturker@dogus.edu.tr
- Danışmanlık saatleri (Dudullu Kampüsü):
  - Salı 13:00-15:00
  - Cuma 12:00-14:00

Kurulum sorunu, ödev takılması ya da ders içeriğiyle ilgili sorular için danışmanlık saatlerine gelebilirsin. E-postada konu satırına "COME 381" yaz ve GitHub kullanıcı adını ekle.
