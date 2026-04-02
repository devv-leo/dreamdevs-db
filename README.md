# Database Schema Design for Greenfield Academy
 
**Status:** ERD complete. Tap [here](https://drive.google.com/file/d/1Zy1hQp9IG4MHYcbmLNP3nqJFHdZU1NDu/view?usp=drive_link) to view on draw.io.

## What we designed

A relational database schema for Greenfield Academy, derived entirely from a plain-English description given by Mrs Adeyemi, Head of Administration. No table list was provided — entities, attributes, relationships, and constraints were all extracted from the description.

The schema has **11 tables** across four logical groups:

| Group | Tables |
|---|---|
| People | `staff`, `teacher`, `student`, `year_group` |
| Curriculum | `course`, `term`, `course_session` |
| Student activity | `enrolment`, `attendance` |
| Extracurricular | `club`, `club_membership` |

## Key design decisions

### 1. `staff` and `teacher` are separate tables

All staff (teaching and contract) share common fields: name, staff ID, phone, email, and staff type. Only teaching staff have a specialisation. Rather than adding a nullable `specialisation` column to `staff` — which would mean nothing for contract staff — a separate `teacher` table holds just that one extra column and references `staff` via a shared primary key (`staff_id`).

This is called a **1-to-1 extension pattern**. It keeps the `staff` table clean and avoids columns that are irrelevant for half the rows.

---

### 2. `course_session` is its own table — not collapsed into `course`

This was the most important structural decision. A course like Mathematics runs multiple times — different terms, different years, different teachers. Each of those is a distinct **session**.

`course_session` holds foreign keys to `course`, `term`, and `teacher`. This means:
- Mathematics in Term 1 of 2025 taught by Mr Okafor is a different row from Mathematics in Term 2 of 2025 taught by Mrs Bello
- The same course data is never duplicated — `course` stays as a single record for Mathematics
- You can query historical sessions cleanly without overwriting anything

Collapsing sessions into courses (putting `term_id` and `teacher_id` directly on `course`) would have broken as soon as a course ran more than once.

---

### 3. `enrolment` is a junction table that carries its own data

Students enrol in sessions, not in courses directly. This is a **many-to-many** relationship (a student can be in many sessions, a session has many students), which requires a junction table.

`enrolment` resolves that relationship but also stores data that only makes sense *in the context of one specific student in one specific session*:
- `enrol_date` — when they joined
- `status` — active, withdrawn, or completed (ENUM)
- `final_mark` — nullable, because results aren't always processed immediately
- `letter_grade` — nullable for the same reason

This is a common real-world pattern: junction tables often become the most data-rich tables in a schema.

---

### 4. `attendance` hangs off `enrolment`, not directly off `student` + `session`

Attendance is recorded per class date, per student, per session. It would seem natural to link attendance straight to a student and a session, but there is a more correct structure: attendance only exists because an enrolment exists first.

By linking `attendance` to `enrolment_id`, we get two things for free:
- We cannot accidentally record attendance for a student who is not enrolled in that session — the foreign key prevents it
- Queries about attendance automatically have access to enrolment status, marks, and grades without extra joins

---

### 5. `club_membership` is a junction table with temporal data

Students can join many clubs, clubs can have many members — another many-to-many relationship. The junction table `club_membership` stores the `term_number` and `academic_year` a student joined, because the description specifically says this should be recorded.

Note: `club_membership` does *not* use a surrogate primary key. The composite of `(student_id, club_id)` is the natural primary key — a student can only join the same club once (you would add a new row if they re-join in a later term, but that is an edge case to discuss in the debrief).

---

### 6. Nullable columns are intentional, not lazy

Two columns on `enrolment` are explicitly nullable: `final_mark` and `letter_grade`. This is a deliberate constraint decision, not an oversight. The description states: *"not all enrolled students receive a final mark immediately — sometimes we are still processing results."*

Making these `NOT NULL` would mean the row cannot exist until results are ready, which is wrong. Nullable here means: *the row exists (the student is enrolled), but this piece of information is not yet known.*

---

### 7. ENUM types are used where the value set is fixed and known

The following columns use ENUM rather than free-text VARCHAR:

| Table | Column | Values |
|---|---|---|
| `staff` | `staff_type` | `teaching`, `contract` |
| `student` | `gender` | `male`, `female`, `other` |
| `enrolment` | `status` | `active`, `withdrawn`, `completed` |
| `attendance` | `status` | `present`, `absent`, `late` |
| `club` | `meeting_day` | `monday` … `friday` |

ENUM enforces the value set at the database level — no application code needed to reject an invalid status like `"absnt"`.

---

### 8. Many-to-many relationships resolved with junction tables

Two M:N relationships were identified and both get junction tables:

| Relationship | Junction table | Extra columns |
|---|---|---|
| Student ↔ Course session | `enrolment` | `enrol_date`, `status`, `final_mark`, `letter_grade` |
| Student ↔ Club | `club_membership` | `term_number`, `academic_year` |

A direct foreign key between students and sessions (or students and clubs) cannot represent M:N — a single FK column can only point to one row.

---

## What is still to do

- Write `CREATE TABLE` statements in the correct order (parent tables before child tables)
- Insert sample data (minimum: 5 students, 3 courses, 3 sessions, 2 clubs, varied statuses)
- Write and run the five required queries (A through E)
- Optionally: attempt the bonus tasks (guardians table, full session check, at-risk students view)

## Table creation order

Because child tables cannot be created before the parent they reference, the correct order is:

1. `year_group`
2. `staff`
3. `teacher`
4. `course`
5. `term`
6. `student`
7. `course_session`
8. `club`

## Group members
- Precious Michael @Eyiza
- Anthony Alikah @dreyyfuss
- Olalekan Olaoye @devv-leo
10. `enrolment`
11. `attendance`
12. `club_membership`
