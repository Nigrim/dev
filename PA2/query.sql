ALTER TABLE hw.vac 
  DROP COLUMN IF EXISTS Professional_roles, 
  DROP COLUMN IF EXISTS Specializations, 
  DROP COLUMN IF EXISTS Profarea_names;

CREATE TABLE IF NOT EXISTS hw.vac_msk
ENGINE = MergeTree()
ORDER BY Ids
AS SELECT
  Ids,
  Employer,
  Name,
  "From",
  "To",
  Experience,
  Schedule,
  Keys,
  Description,
  Published_at
FROM hw.vac
WHERE Area = 'Москва' AND Salary IS NOT NULL;

CREATE TABLE IF NOT EXISTS hw.vac_spb
ENGINE = MergeTree()
ORDER BY Ids
AS SELECT
  Ids,
  Employer,
  Name,
  "From",
  "To",
  Experience,
  Schedule,
  Keys,
  Description,
  Published_at
FROM hw.vac
WHERE Area = 'Санкт-Петербург' AND Salary IS NOT NULL;

DROP TABLE IF EXISTS hw.vac;

SELECT
  'Москва' AS "Местоположение",
  COUNT(*) AS "Кол-во вакансий",
  ROUND(AVG("From")) AS "Средняя начальная зарплата",
  ROUND(AVG("To")) AS "Средний потолок зарплаты"
FROM hw.vac_msk
  UNION ALL
SELECT
  'Санкт-Петербург' AS "Местоположение",
  COUNT(*) AS "Кол-во вакансий",
  ROUND(AVG("From")) AS "Средняя начальная зарплата",
  ROUND(AVG("To")) AS "Средний потолок зарплаты"
FROM hw.vac_spb;

-- в МСк 11,530 вакансий с указанием зарплаты
-- в СПб 6,052 вакансии с указанием зарплаты
