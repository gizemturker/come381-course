# COME 381 Veritabanı Sistemleri — Dönem Projesi

## Senaryo: Veteriner Kliniği Evcil Hayvan ve Aşı/Tedavi Takip Sistemi

Bu proje, bir veteriner kliniğine kayıtlı hayvan sahiplerini (`pet_owner`), görevli veteriner hekimleri (`veterinarian`), kliniğe getirilen evcil hayvanları (`pet`), klinikte uygulanan aşı ve tıbbi işlem kataloğunu (`treatment`) ve hayvanlara uygulanan tedavi/aşı kayıtlarını (`pet_treatment`) yönetmek amacıyla geliştirilmiştir.

## Tasarım Kararı

Bir evcil hayvana zaman içinde birden fazla aşı veya tedavi uygulanabildiği ve aynı aşı/tedavi türü pek çok farklı hayvana yapılabildiği için `pet` ile `treatment` varlıkları arasındaki çoktan-çoğa (M:N) ilişki `pet_treatment` ara tablosu ile modellenmiştir; işlemin yapıldığı tarih (`visit_date`), bir sonraki kontrol/hatırlatma tarihi (`next_due_date`), alınan ücret (`charged_amount`) ve iyileşme takip puanı (`follow_up_score`) doğrudan bu uygulamaya ait olduğu için ara tabloya yerleştirilmiştir. Ayrıca her hayvanın sabit bir sorumlu hekimi olmayabileceği veya hekim klinikten ayrılabileceği düşünülerek `pet` tablosundaki `primary_vet_id` yabancı anahtarı boş bırakılabilir (`NULL`) şekilde tanımlanmıştır.


