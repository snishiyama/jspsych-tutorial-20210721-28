# %%
import pathlib
import json
import pandas as pd

dir_root = pathlib.Path(__file__).parent.parent.parent
dir_data_exp1 = dir_root / 'exp' / 'data' / 'exp1'

# %%
# load all data ----
df_e1 = pd.concat([pd.read_csv(f) for f in dir_data_exp1.glob("*.csv")])

# %%
# demography ----
df_subj_e1 = (
    df_e1
    .loc[:, ["tempID", "age", "sex"]]
    .drop_duplicates()
)

# %%
# flanker ----
df_flanker_e1 = (
    df_e1
    .query('task == "flanker_main"')
    .loc[:, ["tempID", "condition", "rt", "correct"]]
)

# %%
# BIS/BAS ----
df_ques_e1 = (
    df_e1
    .query('task == "bis_bas"')
    .loc[:, ['tempID', 'response']]
)


def json_to_df(tempID, resp):
    dict_x = json.loads(resp)
    new_df = pd.DataFrame(dict_x.values(), index=dict_x.keys(), columns=['value'])
    new_df['tempID'] = tempID
    return new_df


df_bisbas_e1 = pd.concat([json_to_df(id, r) for _, id, r in df_ques_e1.itertuples()])

# add factor names corresponding to the question number
dict_items = {'bis': [13, 10, 15, 6, 20, 18, 1],
              'drive': [7, 2, 9, 17],
              'responsive': [11, 19, 5, 14, 3],
              'seek': [8, 12, 4, 16]}

dict_q_fct = {}
for key, val in dict_items.items():
    for v in val:
        dict_q_fct[f'Q{v}'] = key

df_bisbas_e1['fct_nm'] = df_bisbas_e1.index.map(lambda x: dict_q_fct[x])
