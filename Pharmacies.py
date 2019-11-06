
# coding: utf-8

# In[1]:


import pandas as pd

def main():
    file_name = input("Enter file path: ")

    # In[3]: Read CSV

    data = pd.read_csv(file_name)

    # In[4]:

    data.head()

    # In[5]: Select required columns

    bars_data = data[['Census year', 'Trading name', 'Industry (ANZSIC4) description', 'x coordinate', 'y coordinate']]

    # In[6]: Filter by latest year

    filtered_data = bars_data.loc[bars_data['Census year'] == 2017]

    # In[7]:

    filtered_data.head()

    # In[8]:

    filtered_data.rename(columns={'Industry (ANZSIC4) description': 'Desc'}, inplace=True)

    # In[9]:

    filtered_data.head()

    # In[45]: Filter Pharmacies

    filtered_data = filtered_data.loc[filtered_data['Desc'].isin(
        ['Pharmaceutical, Cosmetic and Toiletry Goods Retailing', 'Pharmaceutical and Toiletry Goods Wholesaling',
         'Police Services', 'Hospitals (except Psychiatric Hospitals)'])]

    # In[46]:

    filtered_data.head()

    # In[28]: Delete all rows with skin, cosmetics and hair products related shops

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Skin")]

    # In[29]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Cosmetic")]

    # In[30]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Hair")]

    # In[31]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Shaver")]

    # In[32]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Body")]

    # In[33]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Mecca")]

    # In[34]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Aesop")]

    # In[35]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Lush")]

    # In[37]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Parlour")]

    # In[38]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("AESOP")]

    # In[39]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Spa")]

    # In[40]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("En Provence")]

    # In[41]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Beauty")]

    # In[43]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Chanel")]

    # In[44]:

    filtered_data = filtered_data[~filtered_data['Trading name'].str.contains("Secret")]

    # In[42]:

    # filtered_data.to_csv(r'C:\Users\megma\Documents\pha.csv',index=False)

    # In[ ]:

    dest_file_name = input("Enter destination file path: ")

    # In[ ]:

    file = dest_file_name + "\pharmacies.csv"

    # In[ ]:

    filtered_data.to_csv(file, index=False)

if __name__ == '__main__':
    main()


