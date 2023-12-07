#Создаем таблицу для каждого года
CREATE TABLE IF NOT EXISTS yearly_summary AS
SELECT
    "year",
    start_station_id AS station_id,
    COUNT(DISTINCT trip_id) AS trips_started,
    0 AS trips_ended, -- Инициализируем нулевым значением для последующего обновления
    COUNT(DISTINCT trip_id) AS trips_total,
    AVG(duration_minutes) AS avg_dur_started,
    0 AS avg_dur_ended -- Инициализируем нулевым значением для последующего обновления
FROM
    trips
WHERE
    "year" BETWEEN 2013 AND 2017
GROUP BY
    "year", start_station_id;

#Обновляем таблицу для учета завершенных поездок
UPDATE
    yearly_summary AS ys
SET
    trips_ended = te.trips_ended,
    trips_total = ys.trips_started + te.trips_ended,
    avg_dur_ended = te.avg_dur_ended
FROM (
    SELECT
        "year",
        end_station_id AS station_id,
        COUNT(DISTINCT trip_id) AS trips_ended,
        AVG(duration_minutes) AS avg_dur_ended
    FROM
        trips
    WHERE
        "year" BETWEEN 2013 AND 2017
    GROUP BY
        "year", end_station_id
) AS te
WHERE
    ys."year" = te."year"
    AND ys.station_id = te.station_id;

#Выводим результат
SELECT * FROM yearly_summary;


#Выбираем данные о поездках, которые завершились на каждой станции за каждый год
WITH trips_ended AS (
  SELECT
    tr."year",
    tr.end_station_id,
    COUNT(DISTINCT tr.trip_id) AS trip_count,
    AVG(tr.duration_minutes) AS avg_dur_ended
  FROM public.trips AS tr
  WHERE tr."year" IS NOT NULL AND tr.end_station_id IS NOT NULL
  GROUP BY tr."year", tr.end_station_id
),

#Выбираем данные о поездках, которые начались на каждой станции за каждый год
trips_started AS (
  SELECT
    tr."year",
    tr.start_station_id,
    COUNT(DISTINCT tr.trip_id) AS trip_count,
    AVG(tr.duration_minutes) AS avg_dur_started
  FROM public.trips AS tr
  WHERE tr."year" IS NOT NULL AND tr.start_station_id IS NOT NULL
  GROUP BY tr."year", tr.start_station_id
),

#Выбираем данные о поездках, которые начались и завершились на одной и той же станции за каждый год
round_trips AS (
  SELECT
    tr."year",
    tr.start_station_id AS station_id,
    COUNT(DISTINCT tr.trip_id) AS trip_count
  FROM public.trips AS tr
  WHERE tr.start_station_id = tr.end_station_id
  GROUP BY tr."year", tr.start_station_id
)

#Объединяем результаты предыдущих запросов для формирования окончательного результата
SELECT
  te."year",
  te.end_station_id,
  te.trip_count AS trips_ended,
  ts.trip_count AS trips_started,
  te.trip_count + ts.trip_count - COALESCE(rt.trip_count, 0) AS trips_total,
  ROUND(ts.avg_dur_started) AS avg_dur_started,
  ROUND(te.avg_dur_ended) AS avg_dur_ended,
  st.name
FROM trips_ended AS te
FULL JOIN trips_started AS ts ON te."year" = ts."year" AND te.end_station_id = ts.start_station_id
LEFT JOIN round_trips AS rt ON rt."year" = ts."year" AND rt.station_id = ts.start_station_id
JOIN public.stations AS st ON te.end_station_id = st.station_id
WHERE st.status = 'active' AND te."year" = 2016
ORDER BY avg_dur_started DESC, st.name
LIMIT 10;
