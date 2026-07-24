/*
Анализ эффективности реферальной программы

Бизнес-вопросы:
1. Сколько приглашений отправили пользователи?
2. Сколько пользователей участвовали в реферальной программе?
3. Какая доля приглашённых пользователей установила игру?
*/

SELECT COUNT(*) AS cnt_invites
     , COUNT(DISTINCT player_id) AS cnt_ref_players
     , SUM(friend_reg_flag) AS success_invites
     , ROUND(SUM(friend_reg_flag) * 100.0 / COUNT(*)) AS share_invites
FROM planet_hunt.invite_network

/*
Вывод:
Пользователи отправили 7 993 приглашения.
В реферальной программе участвовали 2 992 игрока.
36% приглашений привели к регистрации новых пользователей.

Реферальная программа стала дополнительным каналом привлечения игроков.
*/

/*
Дополнительный анализ активности пользователей реферальной программы

Используется для поиска наиболее активных участников программы
и пользователей с высокой эффективностью приглашений.
*/

-- Пользователи, которые чаще всего приглашают друзей

SELECT 
      player_id
    , COUNT(*) AS invites_sent
FROM planet_hunt.invite_network
GROUP BY player_id
ORDER BY invites_sent DESC
LIMIT 50



-- Пользователи с высокой конверсией приглашений

SELECT 
      player_id
    , COUNT(*) AS invites_sent
    , SUM(friend_reg_flag) AS successful_invites
    , ROUND(SUM(friend_reg_flag) * 100.0 / COUNT(*)) AS conversion_rate
FROM planet_hunt.invite_network
GROUP BY player_id
HAVING COUNT(*) > 5
   AND SUM(friend_reg_flag) * 1.0 / COUNT(*) >= 0.5
ORDER BY conversion_rate DESC



-- Пользователи с неэффективными приглашениями

SELECT 
      player_id
    , COUNT(*) AS invites_sent
    , SUM(friend_reg_flag) AS successful_invites
FROM planet_hunt.invite_network
GROUP BY player_id
HAVING COUNT(*) > 6
   AND SUM(friend_reg_flag) = 0
ORDER BY invites_sent DESC