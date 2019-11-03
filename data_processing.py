#!/usr/bin/env python
# coding: utf-8

# In[485]:


import pandas as pd
from fuzzywuzzy import fuzz
import numpy as np

# read csv of food keeper
filename = "FoodKeeper-Data.xlsx"
fkDF = pd.read_excel(filename, sheet_name='Product')
scDF = pd.read_excel(filename, sheet_name='Append')

# remove rows with null vals in refrigerate
fkDF = fkDF[(fkDF.DOP_Refrigerate_Max.notnull()) | (fkDF.Refrigerate_Max.notnull())]
scDF = scDF[scDF.Refrigerate != 0]

scDF = pd.read_excel(filename, sheet_name='Append')
scDF = scDF[scDF.Refrigerate != 0]
scDF['Refrigerate_Metric'] = scDF.Refrigerate

# Clean and scale entries
scDF = scDF[~scDF['Refrigerate'].str.contains('after')]
scDF = scDF[~scDF['Refrigerate'].str.contains('ripe')]
scDF = scDF[~scDF['Refrigerate'].str.contains('date')]
scDF = scDF[~scDF['Refrigerate'].str.contains('depending')]
scDF = scDF[~scDF['Refrigerate'].str.contains('indefinite')]

scDF.Refrigerate_Metric = scDF.Refrigerate_Metric.str.replace('\d+', '')
scDF.Refrigerate_Metric = scDF.Refrigerate_Metric.str.replace('-', '')
scDF.Refrigerate_Metric = scDF.Refrigerate_Metric.str.strip()
scDF.Refrigerate_Metric = scDF.Refrigerate_Metric.str.title()


# Scale units into numbers
def func_Scale(x):
    if x == "Weeks":
        return 7
    elif x == "Months":
        return 30
    elif x == "Days":
        return 1
    elif x == "Years":
        return 360


# Scale values of refrigerate max by units
scDF['Scaled_Metric_Refrigerate'] = scDF.Refrigerate_Metric.apply(func_Scale)
scDF['Scaled_Metric_Refrigerate'] = scDF['Scaled_Metric_Refrigerate'].astype('object')

scDF['RefrigerateFinal'] = scDF.Refrigerate.apply(lambda x: (x.split('-')[0]))
scDF.RefrigerateFinal = scDF.RefrigerateFinal.str.replace('(\D+)', '')
scDF.RefrigerateFinal = scDF.RefrigerateFinal.astype(float)

scDF.RefrigerateFinal = scDF.RefrigerateFinal * scDF.Scaled_Metric_Refrigerate

scDF.Name = scDF.Name.str.capitalize()
scDF.Keywords = scDF.Name.str.capitalize()
scDF = scDF[['Name', 'Keywords', 'RefrigerateFinal']]

# Scale values of refrigerate max by units
fkDF['Scaled_Metric_DOPRefrigerate'] = fkDF.DOP_Refrigerate_Metric.apply(func_Scale)
fkDF['Scaled_Metric_Refrigerate'] = fkDF.Refrigerate_Metric.apply(func_Scale)

fkDF.DOP_Refrigerate_Max = fkDF.DOP_Refrigerate_Max * fkDF.Scaled_Metric_DOPRefrigerate
fkDF.Refrigerate_Max = fkDF.Refrigerate_Max * fkDF.Scaled_Metric_Refrigerate

fkDF['RefrigerateFinal'] = fkDF.DOP_Refrigerate_Max.fillna(0) + fkDF.Refrigerate_Max.fillna(0)

fkDF = fkDF[['Name', 'Keywords', 'RefrigerateFinal']]

concatDF = pd.concat([fkDF, scDF])


def getExpiration(inputFood):
    def getfuzz(x):
        return fuzz.token_set_ratio(x, inputFood)

    fkDF['Fuzz_Value'] = fkDF.Keywords.apply(getfuzz)
    finalRows = fkDF[fkDF.Fuzz_Value > 40]
    MaxRow = finalRows.sort_values('Fuzz_Value', ascending=False)

    tmpNames = [x for x in MaxRow['Keywords']]
    tmpVals = [x for x in MaxRow['RefrigerateFinal']]
    tmp = {}
    count = 0
    #return tmpNames

    for i in range(len(tmpNames)):
        if tmpNames[i]!=tmpNames[i]:
            continue
        if ',' not in tmpNames[i]:
            tmp[tmpNames[i].lower().strip()] = tmpVals[i]
            count +=1
        else:
            a = tmpNames[i].split(",")
            for j in range(len(a)):
                b = a[j].lower().strip()
                if count<=20 and b not in tmp:
                    tmp[b] = tmpVals[i]
                count += 1
    ret = []
    for i in tmp:
        ret.append({'name': i, 'date': tmp[i]})
    if(len(tmp)==0):
        return "ERROR"
    return ret



