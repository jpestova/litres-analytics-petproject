import pandas as pd
import streamlit as st

st.set_page_config(page_title="Litres Analytics Dashboard", layout="wide")
st.title("📚 Litres Analytics Dashboard")

@st.cache_data
def load_data():
    df = pd.read_csv("../data/events.csv", parse_dates=["timestamp"])
    df["date"] = df["timestamp"].dt.date
    return df

df = load_data()

col1, col2, col3 = st.columns(3)
with col1:
    platforms = ["All"] + sorted(df["platform"].unique().tolist())
    platform = st.selectbox("Платформа", platforms, index=0)
with col2:
    sources = ["All"] + sorted(df["source"].unique().tolist())
    source = st.selectbox("Источник", sources, index=0)
with col3:
    ab = ["All"] + sorted(df["ab_group"].unique().tolist())
    ab_group = st.selectbox("A/B группа", ab, index=0)

f = df.copy()
if platform != "All":
    f = f[f["platform"] == platform]
if source != "All":
    f = f[f["source"] == source]
if ab_group != "All":
    f = f[f["ab_group"] == ab_group]

# DAU
dau = f.groupby("date")["user_id"].nunique()
st.subheader("DAU")
st.line_chart(dau)

# Reading funnel (if reader exists)
st.subheader("Воронка чтения (reader)")
fr = f[f["source"] == "reader"]
if not fr.empty:
    openers = fr[fr["event"]=="book_open"].groupby("date")["user_id"].nunique()
    scrollers = fr[fr["event"]=="page_scroll"].groupby("date")["user_id"].nunique()
    finishers = fr[fr["event"]=="book_finished"].groupby("date")["user_id"].nunique()
    funnel = pd.concat([openers.rename("openers"), scrollers.rename("scrollers"), finishers.rename("finishers")], axis=1).fillna(0)
    st.line_chart(funnel)
else:
    st.info("Нет данных по 'reader' в текущем фильтре.")

# AB split summary (finish rate)
st.subheader("A/B: дочитываемость книги")
reader = f[f["source"]=="reader"]
if not reader.empty:
    opens = reader[reader["event"]=="book_open"].groupby("user_id").size().rename("opens")
    finishes = reader[reader["event"]=="book_finished"].groupby("user_id").size().rename("finishes")
    ab = reader.groupby("user_id")["ab_group"].agg(lambda x: x.mode()[0])
    agg = pd.concat([opens, finishes, ab], axis=1).fillna(0)
    agg["finish_rate"] = agg["finishes"]/agg["opens"].replace({0: None})
    st.dataframe(agg.groupby("ab_group")["finish_rate"].mean().to_frame("mean_finish_rate"))
else:
    st.info("Нет данных для A/B с текущими фильтрами.")