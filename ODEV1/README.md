# COME 381 Midterm Project

This project models an event and club management system where members can register for events organized under different categories. Each event belongs to one category, while members and events have a many-to-many relationship. The `event_registration` table is used as a junction table to resolve this many-to-many relationship and to store registration-specific data such as registration time and rating. Separate primary keys are used for all entities, and foreign keys connect events to categories and registrations to members and events.
