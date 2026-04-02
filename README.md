# Database Schema Design for Greenfield Academy

**Status:** ERD complete and SQL implemented.

## What we designed

A relational database schema for Greenfield Academy, derived entirely from a plain-English description given by Mrs Adeyemi, Head of Administration. No table list was provided — entities, attributes, relationships, and constraints were all extracted from the description.

The schema has **10 tables** across four logical groups:

| Group | Tables |
|---|---|
| People | `Student`, `Staff` |
| Curriculum | `Course`, `Session`, `CourseSession` |
| Student activity | `Class`, `Enrollment`, `Attendance` |
| Extracurricular | `Club`, `ClubStudent` |

---

## Key design decisions

### 1. Staff is a single table

All staff (permanent and contract) share the same fields: name, staff ID, phone, email, and specialisation. A single `Staff` table with a `staffType` ENUM column distinguishes them. A separate `teacher` table would only be justified if teaching staff had many extra fields. With one extra attribute (`specialisation`), the overhead of a 1-to-1 extension table is not worth it.

### 2. yearGroup and term are ENUM columns, not lookup tables

Year groups (7 through 11) and terms (1, 2, 3) are small, fixed value sets that will never change. Storing them as ENUMs avoids extra tables and joins while still enforcing valid values at the database level.

### 3. Session represents an academic year

The `Session` table stores academic years (e.g. `2024/2025`) with a start and end date. This gives `CourseSession` a proper time anchor: a course session belongs to a specific term within a specific academic year, not just a floating term number.

### 4. CourseSession is its own table

This was the most important structural decision. A course like Mathematics runs multiple times across different terms, years, and teachers. Each of those is a distinct session. `CourseSession` holds foreign keys to `Course`, `Staff`, and `Session`, plus a `term` ENUM.

Mathematics in Term 1 of 2025/2026 taught by Mr Okafor is a different row from Mathematics in Term 2 taught by Mrs Bello, even though the course is the same. A UNIQUE constraint on `(courseId, term, staffId, sessionId)` enforces this at the database level and prevents duplicate sessions from being created.

### 5. Class represents individual lesson dates

A `Class` is a single scheduled lesson on a specific date within a `CourseSession`. This table exists because attendance is recorded per lesson, not per session as a whole. Without `Class`, there would be no way to record that a student was present on one date but absent on another.

### 6. Enrollment is a junction table that carries data

Students enrol in sessions, not courses directly. This is a many-to-many relationship resolved by `Enrollment`. The table also stores data specific to each student-session pairing: `enrollmentDate`, `enrollmentStatus`, `score`, and `grade`.

`score` and `grade` are explicitly nullable because results are not always processed immediately. Marking them NOT NULL would mean the enrollment row cannot exist until results are ready, which is wrong.

### 7. Attendance links to Student and Class

Attendance is recorded per student per scheduled class. `Attendance` holds foreign keys to `Student` and `Class`, plus an `attendanceStatus` ENUM (`present`, `absent`, `late`). Both foreign keys use `ON DELETE CASCADE` so attendance records are cleaned up automatically if either the student or the class is removed.

### 8. ClubStudent is a junction table with temporal data

Students can join many clubs; clubs can have many members. `ClubStudent` resolves this many-to-many relationship and stores the `term` and `clubYear` (stored as MySQL's `YEAR` type) when the student joined, as the description requires. A surrogate primary key (`clubStudentId`) is used rather than a composite key to allow a student to re-join a club in a later term without a uniqueness conflict.

### 9. ON DELETE rules are defined on every foreign key

| Table | FK column | Rule | Reason |
|---|---|---|---|
| `Club` | `staffId` | RESTRICT | Cannot delete a staff member who leads a club |
| `CourseSession` | `courseId`, `staffId`, `sessionId` | RESTRICT | Protect academic records from accidental deletion |
| `Class` | `courseSessionId` | CASCADE | Classes have no meaning without their parent session |
| `Enrollment` | `studentId` | CASCADE | Enrollment records are removed when a student is deleted |
| `Enrollment` | `courseSessionId` | RESTRICT | Enrollment history is protected from session deletion |
| `Attendance` | `studentId`, `classId` | CASCADE | Attendance records are removed with the student or class |
| `ClubStudent` | `studentId`, `clubId` | CASCADE | Membership records are removed with the student or club |

### 10. ENUM types are used for all fixed value sets

| Table | Column | Values |
|---|---|---|
| `Student` | `gender` | `male`, `female` |
| `Student` | `yearGroup` | `7`, `8`, `9`, `10`, `11` |
| `Staff` | `staffType` | `permanent`, `contract` |
| `CourseSession` | `term` | `1`, `2`, `3` |
| `Enrollment` | `enrollmentStatus` | `active`, `withdrawn`, `completed` |
| `Enrollment` | `grade` | `A`, `B`, `C`, `D`, `E`, `F` |
| `Attendance` | `attendanceStatus` | `present`, `absent`, `late` |
| `Club` | `meetingDay` | `Monday` through `Sunday` |
| `ClubStudent` | `term` | `1`, `2`, `3` |

### 11. Many-to-many relationships resolved with junction tables

| Relationship | Junction table | Extra columns |
|---|---|---|
| Student and CourseSession | `Enrollment` | `enrollmentDate`, `enrollmentStatus`, `score`, `grade` |
| Student and Club | `ClubStudent` | `term`, `clubYear` |

### 12. Uniqueness and check constraints

| Table | Column | Constraint | Reason |
|---|---|---|---|
| `Course` | `shortCode` | UNIQUE | Internal codes like `MATH-101` must be unique |
| `CourseSession` | `(courseId, term, staffId, sessionId)` | UNIQUE | Prevents the same session from being created twice |

---

## Table creation order

Parent tables must be created before the child tables that reference them:

1. `Student`
2. `Staff`
3. `Course`
4. `Session`
5. `Club`
6. `CourseSession`
7. `Class`
8. `Enrollment`
9. `Attendance`
10. `ClubStudent`

---

## Deliverables completed

- [x] ERD designed and reviewed
- [x] `CREATE TABLE` statements written in correct dependency order
- [x] ON DELETE rules defined on every foreign key
- [x] UNIQUE constraints applied on `Course.shortCode` and `CourseSession`
- [x] Sample data inserted (6 students, 4 staff, 3 courses, 2 academic years, 6 course sessions, 9 classes, varied enrollment statuses, mixed attendance, 4 clubs)
- [x] Required queries A through E written and verified

---

## Group members

- Precious Michael
- Anthony Alikah
- Olalekan Olaoye
- John Agene
