import pandas as pd

def main():
    file_name = input("Enter file path: ")
    dfs = pd.read_excel(file_name, sheet_name="Table 07")
    filtered_df = dfs.loc[dfs['Offence Division'].isin(['A Crimes against the person', 'C Drug offences', 'D Public order and security offences'])]
    filtered_df = filtered_df.loc[(filtered_df['Year ending December'] >= (filtered_df['Year ending December'].max() - 4))]
    filtered_df = filtered_df.loc[filtered_df['Offence Subdivision'].isin(
        ['A20 Assault and related offences', 'A70 Stalking, harassment and threatening behaviour',
         'A80 Dangerous and negligent acts endangering people', 'C10 Drug dealing and trafficking',
         'C20 Cultivate or manufacture drugs', 'C30 Drug use and possession', 'C90 Other drug offences',
         'D20 Disorderly and offensive conduct', 'D30 Public nuisance offences', 'D40 Public security offences'])]
    filtered_df = filtered_df.loc[~filtered_df['Offence Subgroup'].isin(
        ['C22 Manufacture drugs', 'C21 Cultivate drugs', 'D21 Riot and affray', 'D32 Hoaxes', 'D33 Begging',
         'D34 Defamation and libel', 'D41 Immigration offences', 'D43 Hacking', 'D44 Terrorism offences'])]
    dest_file_name = input("Enter destination file path: ")
    file = dest_file_name + "\Offences.csv"
    filtered_df.to_csv(file, index=False)

if __name__ == '__main__':
    main()

