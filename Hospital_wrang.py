
# coding: utf-8

# In[2]:


import pandas as pd


def main():
    # In[3]:

    file_name = input("Enter file path: ")

    # In[4]:

    data = pd.read_csv(file_name)

    # In[5]:

    #data.head()

    # In[6]: Select required columns

    hosp_data = data[['X', 'Y', 'LabelName', 'StreetNum', 'RoadName', 'RoadType', 'LGAName', 'Postcode', 'State']]

    # In[7]:

    #hosp_data.head()

    # In[8]: Filter Hospitals based on the names.

    hosp_data = hosp_data[~hosp_data['LabelName'].str.contains("Skin")]

    # In[9]:

    hosp_data = hosp_data[~hosp_data['LabelName'].str.contains("Eye")]

    # In[10]:

    hosp_data = hosp_data[~hosp_data['LabelName'].str.contains("Cancer")]

    # In[11]:

    hosp_data = hosp_data[~hosp_data['LabelName'].str.contains("Endoscopy")]

    # In[13]:

    hosp_data = hosp_data[~hosp_data['LabelName'].str.contains("Dialysis")]

    # In[15]:

    hosp_data = hosp_data[~hosp_data['LabelName'].str.contains("Plastic")]

    # In[ ]:

    dest_file_name = input("Enter destination file path: ")

    # In[ ]:

    file = dest_file_name + "\Hosp.csv"

    # In[ ]:

    hosp_data.to_csv(file, index=False)


if __name__ == '__main__':
    main()


# In[14]:


#hosp_data.to_csv(r'C:\Users\megma\Documents\ho.csv',index=False)

