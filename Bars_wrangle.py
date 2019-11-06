
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:
def main():
    file_name = input("Enter file path: ")

    # In[3]: Read CSV File

    data = pd.read_csv(file_name)

    # In[5]: Select the columns required

    bars_data = data[
        ['Census year', 'Street address', 'CLUE small area', 'Trading name', 'x coordinate', 'y coordinate']]

    # In[7]: Filter Data according to the year

    filtered_data = bars_data.loc[bars_data['Census year'] == 2017]

    # In[8]:

    filtered_data = filtered_data.drop(['Census year'], axis=1)

    # In[9]:

    filtered_data.head()

    # In[ ]:

    dest_file_name = input("Enter destination file path: ")

    # In[ ]: Save the wrangled data in the form of CSV.

    file = dest_file_name + "\Bars.csv"

    # In[ ]:

    filtered_data.to_csv(file, index=False)

if __name__ == '__main__':
    main()

