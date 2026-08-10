-- Анализ эффективности реферальной программы
-- Расчёт K-factor и прогноз количества пользователей, привлечённых будущей средней когортой

WITH invites AS
(SELECT pp.player_id
      , COUNT (friend_reg_flag) AS cnt_inv -- количество приглашений на одного человека
      , SUM (COALESCE (friend_reg_flag, 0)) AS cnt_reg -- количество зарегистрировавшихся на одного человека
FROM planet_hunt.players_profile AS pp
LEFT JOIN planet_hunt.invite_network AS inv -- учитываем тех пользователей, которые никого не приглашали
       ON inv.player_id = pp.player_id
GROUP BY pp.player_id
ORDER BY pp.player_id
)
,

k_faktor AS
(select AVG (cnt_inv) AS avg_cnt_inv -- среднее количество приглашений
      , SUM (cnt_reg)::numeric / SUM (cnt_inv) AS avg_cnt_reg -- доля приглашённых друзей, которые зарегистрировались в игре
FROM invites
)
,

cohort AS -- объём каждой когорты
(SELECT DATE_TRUNC ('month', registration_date) AS mm
      , COUNT (*) AS users
FROM planet_hunt.players_profile
GROUP BY mm
ORDER BY mm ASC
)
,

avg_coh_size AS
(SELECT AVG (users) AS avg_size -- средний объём когорты
FROM cohort
)

-- Прогноз количества пользователей, которых привлечёт будущая средняя когорта
-- Расчёт учитывает историческую эффективность реферальной программы
SELECT  avg_cnt_inv * avg_cnt_reg AS k_factor
       , avg_cnt_inv * avg_cnt_reg * avg_size AS plus_users
       , avg_size AS cohort_size
FROM k_faktor, avg_coh_size
