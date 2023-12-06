-- Создаем временную таблицу для хранения уникальных идентификаторов активных станций
CREATE TEMPORARY TABLE IF NOT EXISTS active_station_ids AS
SELECT DISTINCT station_id
FROM public.stations
WHERE status = 'active';

-- Формируем таблицу для каждого года
WITH yearly_data AS (
  SELECT
    s.station_id,
    EXTRACT(YEAR FROM t.start_time) AS year,
    COUNT(DISTINCT t.trip_id) FILTER (WHERE t.start_station_id = s.station_id) AS started_trips,
    COUNT(DISTINCT t.trip_id) FILTER (WHERE t.end_station_id = s.station_id) AS ended_trips,
    COUNT(DISTINCT t.trip_id) FILTER (WHERE t.start_station_id = s.station_id OR t.end_station_id = s.station_id) AS total_trips,
    AVG(t.duration_minutes) FILTER (WHERE t.start_station_id = s.station_id) AS avg_duration_started,
    AVG(t.duration_minutes) FILTER (WHERE t.end_station_id = s.station_id) AS avg_duration_ended
  FROM
    active_station_ids s
  LEFT JOIN
    public.trips t ON s.station_id = ANY(ARRAY[t.start_station_id, t.end_station_id])
  WHERE
    EXTRACT(YEAR FROM t.start_time) BETWEEN 2013 AND 2017
    AND s.status = 'active'
  GROUP BY
    s.station_id, year
)

-- Витрина данных
SELECT
  station_id,
  year,
  SUM(started_trips) AS started_trips,
  SUM(ended_trips) AS ended_trips,
  SUM(total_trips) AS total_trips,
  ROUND(AVG(avg_duration_started), 2) AS avg_duration_started,
  ROUND(AVG(avg_duration_ended), 2) AS avg_duration_ended
FROM yearly_data
GROUP BY
  station_id, year
ORDER BY
  station_id, year;
