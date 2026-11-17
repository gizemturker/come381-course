# ER Diyagramı — Kültür ve Sanat Merkezi Atölye Yönetim Sistemi

Aşağıdaki ER diyagramı, Kültür ve Sanat Merkezi Atölye Yönetim Sistemi'ndeki varlıkları, niteliklerini ve varlıklar arasındaki kardinalite kısıtlarını göstermektedir.

- Bir **eğitmen (`INSTRUCTOR`)** sıfır veya birden fazla **atölye (`WORKSHOP`)** verebilir; her atölyeyi tam bir eğitmen yönetir (`1:N`).
- Bir **stüdyo/salon (`ROOM`)** sıfır veya birden fazla **atölyeye (`WORKSHOP`)** ev sahipliği yapabilir; her atölye en fazla bir fiziksel salonda yapılır (`0..1:N`).
- Bir **kursiyer (`STUDENT`)** birden fazla **atölyeye (`WORKSHOP`)** kaydolabilir ve bir atölyeye birden fazla kursiyer katılabilir; bu çoktan-çoğa (`M:N`) ilişki **`ENROLLMENT`** ara tablosu ile modellenmiştir.

```mermaid
erDiagram
    INSTRUCTOR ||--o{ WORKSHOP : "leads"
    ROOM |o--o{ WORKSHOP : "hosts"
    STUDENT ||--o{ ENROLLMENT : "registers"
    WORKSHOP ||--o{ ENROLLMENT : "has"

    INSTRUCTOR {
        int instructor_id PK
        string full_name
        string email
        string specialty
        string city
        numeric hourly_rate
        date hire_date
    }

    ROOM {
        int room_id PK
        string room_name
        int floor_no
        int max_capacity
    }

    STUDENT {
        int student_id PK
        string full_name
        string email
        string city
        string membership_level
        date registered_at
    }

    WORKSHOP {
        int workshop_id PK
        string title
        string category
        int instructor_id FK
        int room_id FK
        date start_date
        date end_date
        int quota
        numeric fee
    }

    ENROLLMENT {
        int enrollment_id PK
        int student_id FK
        int workshop_id FK
        date enrolled_at
        string attendance_status
        numeric paid_amount
        int rating
    }
```
