# Kurulum Rehberi

Hedef: bilgisayarında PostgreSQL 18 çalışsın, `psql` ile ilk sorgunu yazasın ve ilk commit'in GitHub'da olsun. Takılırsan 5 dakikadan fazla uğraşma, ofis saatinde birlikte çözelim.

## 1. GitHub hesabı

1. github.com'da hesap aç. Özgeçmişe yazabileceğin bir kullanıcı adı seç.
2. E-postanı doğrula.
3. İki adımlı doğrulamayı (2FA) aç: Settings, Password and authentication. Kurtarma kodlarını güvenli bir yere kaydet.
4. github.com/settings/emails sayfasında "Keep my email addresses private" seçeneğini işaretle ve `noreply` adresini kopyala.
5. Şifreni kimseyle paylaşma, benimle de. Senden hiçbir zaman şifre istemeyeceğim.

## 2. Araçları kur

### macOS (Terminal)

```bash
brew install git python gh
brew install --cask visual-studio-code
brew install postgresql@18
brew services start postgresql@18
echo 'export PATH="$(brew --prefix postgresql@18)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Homebrew yoksa önce https://brew.sh adresindeki kurulumu yap.

### Windows (PowerShell)

```powershell
winget install --id Git.Git -e
winget install --id Python.Python.3.13 -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id GitHub.cli -e
```

PostgreSQL 18: https://www.postgresql.org/download/windows adresinden yükleyiciyi indir. Kurulumda `postgres` kullanıcısı için belirlediğin şifreyi bir yere not et. Stack Builder kutusunun işaretini kaldırabilirsin.

### Kontrol

```bash
psql --version
```

`18.x` yazmalı. Olmadıysa PATH'i kontrol et (Windows: `C:\Program Files\PostgreSQL\18\bin`) ve terminali yeniden aç.

## 3. İlk veritabanı ve ilk sorgu

```bash
createdb come381
psql come381
```

Windows ve Docker'da komutlara `-U postgres` ekle.

```sql
SELECT LEAST(7, 3, 9, 1, 5);
SELECT MIN(n) FROM (VALUES (7),(3),(9),(1),(5)) AS t(n);
SELECT version();
```

İlk ikisi `1` döndürmeli. SQL komutları `;` ile biter. `\` ile başlayan psql komutları `;` istemez:

| Komut | Ne yapar |
|---|---|
| `\l` | Veritabanlarını listeler |
| `\c come381` | Veritabanına bağlanır |
| `\dt` | Tabloları listeler |
| `\?` | psql yardımı |
| `\q` | psql'den çıkar |

## 4. İlk repo ve ilk commit

```bash
git config --global user.name "Ad Soyad"
git config --global user.email "...@users.noreply.github.com"
gh auth login
gh repo create come381-week1-KULLANICIADI --private --add-readme --clone
cd come381-week1-KULLANICIADI
```

Git'te bir değişikliği kaydetmek üç adımdır: `git add` (hazırlık alanına koy), `git commit` (kaydet), `git push` (GitHub'a gönder). Repo ayarlarından (Settings, Collaborators) `gizemturker` kullanıcısını ortak çalışan olarak ekle.

## Sorun giderme

| Belirti | Olası neden |
|---|---|
| `brew: command not found` | Homebrew kurulmamış ya da kurulum sonunda yazdığı iki satır çalıştırılmamış |
| `psql` bulunamadı | PATH eklenmemiş ya da terminal yeniden açılmamış |
| `role does not exist` | Windows/Docker'da `-U postgres` unutulmuş |
| `connection refused` | PostgreSQL servisi çalışmıyor |
| `git push` şifre istiyor | `gh auth login` yapılmamış |
| Commit'te "Please tell me who you are" | `git config` adımı atlanmış |
| Komut yanıt vermiyor, istem `come381-#` oldu | Noktalı virgül unutulmuş, `;` yazıp Enter'a bas |
