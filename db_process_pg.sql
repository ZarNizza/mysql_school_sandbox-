-- -Сколько проведено предметов учителями за дату (Учитель, Предмет, Кол-во уроков)
--
DROP PROCEDURE IF EXISTS count_lessons_by_Teacher;

CREATE OR REPLACE PROCEDURE count_lessons_by_Teacher (delta INT) -- параметр определяет смещение даты отчёта в прошлое относительно "сегодня", 1 === "вчера"
as $$
DECLARE log_date DATE := CURRENT_DATE;
BEGIN

-- отчётная дата
IF delta > 0 THEN
  log_date := CURRENT_DATE - interval cast(delta as text)||' days';
END IF;

SELECT
  t.lastName,
  t.firstName,
  t.patronym,
  s.name,
  COUNT(*)
FROM
  tutors t
  LEFT JOIN log l ON t.id = l.tutor
  LEFT JOIN subjects s ON l.subj = s.id
WHERE
  (l.log_date = log_date)
GROUP BY
  t.lastName,
  t.firstName,
  t.patronym,
  s.name
ORDER BY
  t.lastName,
  t.firstName,
  t.patronym,
  s.name;

END
$$ language plpgsql;

CALL count_lessons_by_Teacher (0);

-- -Учителя, которые не работали за дату (Учитель)
--
DROP PROCEDURE IF EXISTS count_idle_Teachers;

DELIMITER / /
CREATE PROCEDURE count_idle_Teachers (delta INT) -- параметр определяет смещение даты отчёта в прошлое относительно "сегодня", 1 === "вчера"
BEGIN
DECLARE log_date DATE DEFAULT (CURRENT_DATE);

-- отчётная дата
IF delta > 0 THEN
SET
  log_date = DATE_SUB (CURRENT_DATE, delta);

END IF;

START TRANSACTION;

SELECT
  log_date,
  t.lastName,
  t.firstName,
  t.patronym
FROM
  tutors AS t
WHERE
  NOT (
    SELECT
      COUNT(*)
    FROM
      log AS l
    WHERE
      (
        l.log_date = log_date
        AND l.tutor = t.id
      )
  )
GROUP BY
  t.lastName,
  t.firstName,
  t.patronym
ORDER BY
  t.lastName,
  t.firstName,
  t.patronym;

COMMIT;

END / / DELIMITER;

-- для целей этой задачи добавляем гарантированно не работавших учителей:
-- Соня спит сегодня, но работала вчера,
-- Ядвига не работала никогда.
-- Запуск с параметром (0) покажет обеих,
-- запуск с параметром (1) покажет только Ядвигу.
--
INSERT INTO
  tutors (lastName, firstName, patronym)
VALUES
  ("Яндексон", "Соня", "Стахановна");

INSERT INTO
  tutors (lastName, firstName, patronym)
VALUES
  ("Яндексон", "Ядвига", "Стахановна");

INSERT INTO
  log(log_date, time_slot, class, subj, tutor, size)
VALUES
  (
    DATE_SUB (CURRENT_DATE, 1),
    1,
    1,
    1,
    (
      SELECT
        id
      FROM
        tutors
      WHERE
        lastName = 'Яндексон'
        AND firstName = 'Соня'
        AND patronym = 'Стахановна'
    ),
    11
  );

CALL count_idle_Teachers (0);

-- -Отчет за дату (Класс, Предмет, Учитель, Всего детей в классе(сколько должно быть), Всего детей на уроке (сколько пришло))
DROP PROCEDURE IF EXISTS count_Pupils_attendance;

DELIMITER / /
CREATE PROCEDURE count_Pupils_attendance (delta INT) -- параметр определяет смещение даты отчёта в прошлое относительно "сегодня", 1 === "вчера"
BEGIN
DECLARE log_date DATE DEFAULT (CURRENT_DATE);

-- отчётная дата
IF delta > 0 THEN
SET
  log_date = DATE_SUB (CURRENT_DATE, delta);

END IF;

START TRANSACTION;

SELECT
  log_date,
  CONCAT(CAST(c.grade AS CHAR(2)), c.symbol) AS class,
  l.time_slot AS 'Lesson',
  s.name,
  t.lastName,
  t.firstName,
  t.patronym,
  l.size AS 'Pupils amount',
  c.size AS 'All'
FROM
  log AS l
  LEFT JOIN classes AS c ON l.class = c.id
  LEFT JOIN tutors AS t ON l.tutor = t.id
  LEFT JOIN subjects AS s ON l.subj = s.id
WHERE
  l.log_date = log_date
GROUP BY
  log_date,
  c.grade,
  c.symbol,
  l.time_slot,
  s.name,
  t.lastName,
  t.firstName,
  t.patronym,
  c.size,
  l.size
ORDER BY
  c.grade,
  c.symbol,
  l.time_slot;

COMMIT;

END / / DELIMITER;

CALL count_Pupils_attendance (0);

-- -Учитель и предмет за месяц, с наименьшей посещаемостью (процент от общего кол-ва. нужно найти запись с минимальным процентом).
-- поскольку Предмет могут вести разные Учителя — имеет смысл разделить эти запросы, определить минимальные посещения отдельно для Учителей и для Предметов.
-- сравниваем средние арифметические отношений посещаемости к списочной величине класса
-- для Учителей
--
DROP PROCEDURE IF EXISTS count_denied_Tutors;

DELIMITER / /
CREATE PROCEDURE count_denied_Tutors ()
BEGIN
DECLARE log_start_date DATE DEFAULT (DATE_SUB (CURRENT_DATE, INTERVAL '1 MONTH'));

DECLARE log_finish_date DATE DEFAULT (CURRENT_DATE);

START TRANSACTION;

SELECT
  t.lastName,
  t.firstName,
  t.patronym,
  cnt.count
FROM
  tutors AS t,
  (
    SELECT
      AVG(l.size / c.size) * 100 AS count,
      l.tutor AS tutor
    FROM
      log AS l,
      classes AS c
    WHERE
      l.class = c.id
      AND l.log_date BETWEEN log_start_date AND log_finish_date
    GROUP BY
      tutor
    ORDER BY
      count ASC
    LIMIT
      1
  ) AS cnt
WHERE
  t.id = cnt.tutor;

COMMIT;

END / / DELIMITER;

CALL count_denied_Tutors ();

-- для Предметов
--
DROP PROCEDURE IF EXISTS count_denied_Subjects;

DELIMITER / /
CREATE PROCEDURE count_denied_Subjects ()
BEGIN
DECLARE log_start_date DATE DEFAULT (DATE_SUB (CURRENT_DATE, INTERVAL '1 MONTH'));

DECLARE log_finish_date DATE DEFAULT (CURRENT_DATE);

START TRANSACTION;

SELECT
  s.grade,
  s.name,
  cnt.count
FROM
  subjects AS s,
  (
    SELECT
      AVG(l.size / c.size) * 100 AS count,
      l.subj AS subj
    FROM
      log AS l,
      classes AS c
    WHERE
      l.class = c.id
      AND l.log_date BETWEEN log_start_date AND log_finish_date
    GROUP BY
      subj
    ORDER BY
      count ASC
    LIMIT
      1
  ) AS cnt
WHERE
  s.id = cnt.subj;

COMMIT;

END / / DELIMITER;

CALL count_denied_Subjects ();

-- для комбинации Учитель/Предмет
--
DROP PROCEDURE IF EXISTS count_denied_synthetic_Subjects_and_Tutors;

CREATE PROCEDURE count_denied_synthetic_Subjects_and_Tutors () language plpgsql as $$
DECLARE log_start_date DATE DEFAULT (CURRENT_DATE - INTERVAL '1 MONTH');
log_finish_date DATE DEFAULT (CURRENT_DATE);
BEGIN CREATE TABLE abc AS
SELECT s.grade,
  s.name,
  t.lastName,
  t.firstName,
  t.patronym,
  cnt.count
FROM subjects AS s,
  tutors AS t,
  (
    SELECT AVG(l.size / c.size) * 100 AS count,
      l.subj AS subj,
      l.tutor AS tutor
    FROM log AS l,
      classes AS c
    WHERE l.class = c.id
      AND l.log_date BETWEEN log_start_date AND log_finish_date
    GROUP BY subj,
      tutor
    ORDER BY count ASC
    LIMIT 10
  ) AS cnt
WHERE s.id = cnt.subj
  AND t.id = cnt.tutor
ORDER BY cnt.count;
--COMMIT;
--RETURN abc;
END;
$$
CALL count_denied_synthetic_Subjects_and_Tutors ();

SELECT
  *
FROM
  abc;