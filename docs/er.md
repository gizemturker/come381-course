erDiagram
    STUDENT {
        INTEGER student_id PK
        VARCHAR full_name
        VARCHAR email UK
        VARCHAR department
        VARCHAR city
    }

    COMPANY {
        INTEGER company_id PK
        VARCHAR company_name
        VARCHAR industry
    }

    INTERNSHIP {
        INTEGER internship_id PK
        INTEGER company_id FK
        VARCHAR title
        TEXT description
        DATE application_deadline
        INTEGER capacity
        DATE start_date
        DATE end_date
    }

    APPLICATION {
        INTEGER application_id PK
        INTEGER student_id FK
        INTEGER internship_id FK
        DATE application_date
        VARCHAR status
    }

    COMPANY ||--o{ INTERNSHIP : publishes
    STUDENT ||--o{ APPLICATION : submits
    INTERNSHIP ||--o{ APPLICATION : receives