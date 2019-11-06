
# coding: utf-8

# In[1]:


import pandas as pd
import datetime


def main():
    # Enter the file path where the original csv is stored.

    file_name = input("Enter file path: ")

    # In[3]: Read CSV

    data = pd.read_csv(file_name)

    # In[4]:

    data.head()

    # In[62]: Select necessary columns

    data1 = data[['ACCIDENT_DATE', 'ACCIDENT_TIME', 'DAY_OF_WEEK', 'ALCOHOL_RELATED', 'LONGITUDE', 'LATITUDE']]

    # In[63]:

    data1.head()

    # In[64]: Filter data

    filtered_data = data1.loc[data1['ALCOHOL_RELATED'] == "Yes"]

    # In[65]:

    filtered_data.head()

    # In[66]:

    len(filtered_data.index)

    # In[67]: Change time to numeric for further processing

    filtered_data['ACCIDENT_TIME'] = filtered_data['ACCIDENT_TIME'].replace('.00', '', regex=True)

    # In[68]:

    filtered_data.head()

    # In[69]:

    filtered_data = filtered_data.drop(['ALCOHOL_RELATED'], axis=1)

    # In[70]:

    filtered_data.head()

    # In[71]: Convert date to timestamp in Pandas

    filtered_data['ACCIDENT_DATE'] = filtered_data['ACCIDENT_DATE'].apply(
        lambda date_string: datetime.datetime.strptime(date_string, "%d/%m/%Y"))

    # In[72]:

    filtered_data.head()

    # In[73]: Find the day for dates missing.

    filtered_data['Day'] = filtered_data['ACCIDENT_DATE'].apply(lambda time: time.dayofweek)

    # In[74]:

    filtered_data.head()

    # In[75]: Use list of days to find the day corresponding to the number found in the previous step

    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    # In[76]:

    filtered_data['DAY_OF_WEEK'] = filtered_data['Day'].apply(lambda day: days[day])

    # In[79]:

    filtered_data.head()

    # In[78]:

    filtered_data = filtered_data.drop(['Day'], axis=1)

    # In[ ]:

    dest_file_name = input("Enter destination file path: ")

    # In[ ]:

    file = dest_file_name + "\Crashes_Last_Five_Years_Wrangled.csv"

    # In[ ]:

    filtered_data.to_csv(file, index=False)

if __name__ == '__main__':
    main()



# In[43]:


#filtered_data.to_csv(r'C:\Users\megma\Documents\acc.csv',index=False)

