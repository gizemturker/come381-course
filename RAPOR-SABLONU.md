# 1 sayfalık ödev raporu: şablon

Bu şablonu her ödevde aynen kullanacaksın. Her ödev için ayrı bir rapor yazarsın. Rapor 15 puandır; puanlama aşağıdaki tabloda, ödevin kendi notlandırma bölümünde de aynı şekilde yazılıdır.

## Kısaca kurallar

- **Biçim:** A4, tek sayfa.
- **İki kopya:** (a) repoda PDF: `reports/odev-N-rapor.pdf` (N yerine ödev numarası: `odev-1-rapor.pdf`, `odev-2-rapor.pdf`, `odev-3-rapor.pdf`); (b) aynısının basılı çıktısı. Basılı raporu ilk derste teslim edersin ve o ödeve ait yoklama tutanağını imzalarsın.
- **Repo bağlantısı:** raporun içine yazma. Tüm ödevlerin aynı repoda olduğundan bağlantıyı derste birlikte kontrol edeceğiz.
- **Uzunluk:** 250-350 kelime. Tek sayfaya sığmıyorsa kısalt; ikinci sayfa okunmaz.
- **Dil:** Türkçe, kendi cümlelerinle. Rapor senin ne düşündüğünü görmek için var; yapay zekanın yazdığı genel bir metin işine yaramaz.
- **Gizli bilgi:** Şifre, token ya da kişisel veri yazma.

## Raporun iskeleti

Sayfanın en üstüne tek satırlık başlık yaz:

```
Ad Soyad | Öğrenci No | Bölüm | Şube | GitHub: kullanici_adi | Ödev N
```

Sonra beş bölümü bu sırayla ve bu başlıklarla yaz:

| # | Bölüm başlığı | Ne yazacaksın | Uzunluk |
|---|---|---|---|
| 1 | Ne yaptım | Ödevde ne kurduğunu, hangi dosyaları ürettiğini anlat | 3-4 cümle |
| 2 | En önemli iki karar ve gerekçesi | Yaptığın iki tasarım kararı, her biri için "neden böyle yaptım" | 2 karar, her biri 2-3 cümle |
| 3 | Beklemediğim şey / yaptığım hata | Beklediğinden farklı çıkan ya da yanlış yaptığın bir şey ve nasıl düzelttiğin | 3-4 cümle |
| 4 | Yapay zeka kullanımı | Neyi neyle yaptırdın, ne buldun. `AI_LOG.md` varsa hangi başlığa bakılacağını yaz; kullanmadıysan "kullanmadım" yaz | 2-3 cümle |
| 5 | Öz kontrol | Ödevdeki teslim listesinin hangi maddeleri tamam, hangileri değil | Kısa liste |

Bölüm 5'te işaretlemediğin bir maddeyi saklama. "Bu madde eksik, çünkü ..." yazmak, hiç yazmamaktan daha çok puan alır.

## Doldurulmuş örnek parça

Aşağıdaki örnek hayali bir "kulüp" senaryosu. Kendi senaryonu yazarken cümleleri kopyalama; yalnızca ne kadar somut olunabileceğine bak.

```
Elif Örnek | 20260000 | Yönetim Bilişim Sistemleri | Şube 2 | GitHub: elif-ornek | Ödev 1

1) Ne yaptım
Üniversite satranç kulübü için bir veritabanı tasarladım. docs/er.md'de
üç varlık (member, event, venue) ve bir ara tablo (event_registration)
var. sql/schema.sql temiz bir veritabanında hatasız çalışıyor.
README'ye senaryoyu ve tasarım kararımı yazdım.

2) En önemli iki karar ve gerekçesi
Karar 1: Üye ile etkinlik arasındaki M:N ilişkiyi event_registration ara
tablosuyla kurdum. Çünkü bir üye birçok etkinliğe, bir etkinlik birçok
üyeye bağlı; tek bir tabloya sığmıyordu.
Karar 2: Etkinlik yerini event içinde metin olarak tutmak yerine ayrı
venue tablosu açtım. Aynı salon birçok etkinlikte geçiyor; adı her
satırda yazarsam bir yazım hatası aynı salonu iki farklı salon yapar.

3) Beklemediğim şey / yaptığım hata
İlk denemede event_registration'ı member'dan önce oluşturdum ve
psql "relation member does not exist" hatası verdi. Foreign key'in
gösterdiği tablonun önce var olması gerektiğini fark ettim. Tabloların
sırasını değiştirdim, dropdb ile baştan çalıştırdım, hata kalmadı.

4) Yapay zeka kullanımı
ER diyagramının Mermaid sözdizimini yazarken yapay zekadan yardım
aldım; ayrıntı AI_LOG.md içinde "Ödev 1" başlığında. Önerdiği
diyagramda venue ile event arasındaki kardinaliteyi ters yazmıştı,
kendim düzelttim.

5) Öz kontrol
[x] er.md GitHub'da çizim olarak görünüyor
[x] schema.sql hatasız çalışıyor
[x] README'de senaryo ve karar var
[x] Rapor PDF'i reports/odev-1-rapor.pdf yolunda
```

Bu örnek yaklaşık 200 kelime; senin raporun biraz daha ayrıntılı olacak ve 250-350 kelimeye ulaşacak.

## Rapor nasıl puanlanır (15 puan)

| Ölçüt | Puan | Ne aranır |
|---|---|---|
| Beş bölüm (Ne yaptım, İki karar ve gerekçe, Beklemediğim şey / hata, Yapay zeka kullanımı, Öz kontrol) | 5 x 3 = 15 | Her bölüm dolu ve somut: 3; yarım ya da genel: 1-2; boş: 0 |

Not: Bölüm 4'te yapay zekayı hiç kullanmadıysan "kullanmadım" yazman yeter. Ödev 2'de `AI_LOG.md` zaten zorunlu.

**Rapor teslim edilmezse yalnızca rapor puanı (15) 0 olur; ödevin geri kalanı yine değerlendirilir.**
Basılı rapor ilk derste verilir. Geç gelen ödev 100 yerine 80 üzerinden değerlendirilir.
