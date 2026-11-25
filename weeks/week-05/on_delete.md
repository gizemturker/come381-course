# Silme politikaları
- category → book: RESTRICT; kitap bulunan kategori silinemez.
- reader → loan: RESTRICT; ödünç geçmişi korunur.
- book → loan: CASCADE; bu örnek modelde kitap silinirse ilişkili kayıtlar silinir. Gerçek kütüphanelerde geçmişi korumak için RESTRICT veya arşivleme tercih edilebilir.
CASCADE ve RESTRICT testleri violations.sql içindedir.
