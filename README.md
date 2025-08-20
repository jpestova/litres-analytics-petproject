# 📚 Litres Analytics Pet-Project

Проект продуктового аналитика для книжного сервиса (читалка и аудиоплеер) с упором на событийную аналитику, метрики и A/B-тесты.

## 🎯 Цели
- Аналитика событий (reader/player), сегменты пользователей, платформы.
- Метрики: DAU/MAU, Retention, воронка.
- A/B-тест: влияние уведомления о бейджах на дочитываемость книги.
- Дашборд для менеджмента (Streamlit).
- SQL-расчёты для ClickHouse.

## 📂 Структура
```
litres-analytics-petproject/
│── data/
│   └── events.csv
│
│── sql/
│   ├── dau_mau.sql
│   ├── retention.sql
│   ├── top_genres.sql
│   ├── conversion_funnel.sql
│   └── ab_test_finishing.sql
│
│── notebooks/
│   ├── 01_exploration.ipynb
│   ├── 02_metrics.ipynb
│   └── 03_ab_test.ipynb
│
│── dashboard/
│   └── app.py
│
│── README.md
```
## 🗄️ Данные
Синтетический датасет `events.csv` за июль 2025 (31 день):
- `user_id`, `timestamp`, `event`, `book_id`, `genre`, `platform`, `source`, `ab_group`.
- События reader: `book_open`, `page_scroll`, `bookmark_added`, `book_finished`, `book_abandoned`, `badge_viewed`, `badge_earned`.
- События player: `track_play`, `pause`, `seek`, `track_finished`, `badge_viewed`, `badge_earned`.
- A/B: группа **B** получает уведомление о бейджах (ожидаемый uplift финализации чтения).

## 🧮 Быстрый старт (локально)
```bash
git clone <your-repo-url>.git
cd litres-analytics-petproject

# Запуск дашборда
cd dashboard
pip install -r requirements.txt  # или установите вручную streamlit pandas matplotlib scipy
streamlit run app.py
```

## 🧪 Ноутбуки
1. **01_exploration.ipynb** — первичный обзор данных.
2. **02_metrics.ipynb** — метрики (DAU/MAU, retention, воронка) + графики.
3. **03_ab_test.ipynb** — A/B-тест дочитываемости с Welch t-test.

## 🧰 SQL
Запросы для ClickHouse.

## 📈 Результаты
- В проекте заложен небольшой uplift дочитываемости у группы B (за счёт уведомления о бейджах).
- Проверить значимость можно в ноутбуке `03_ab_test.ipynb`.

## 🔧 Требования
- Python 3.10+
- `pandas`, `matplotlib`, `scipy`, `streamlit`, `numpy`, `nbformat` (для генерации ноутбуков не требуется на стороне пользователя).

---

> Проект учебный. Все данные синтетические и не отражают реальную статистику.
