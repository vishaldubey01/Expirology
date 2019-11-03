import pandas as pd
from fuzzywuzzy import fuzz

# read csv of food keeper
filename = "FoodKeeper-Data.xls"
fkDF = pd.read_excel(filename, sheet_name='Product')

# remove rows with null vals in refrigerate
fkDF = fkDF[(fkDF.DOP_Refrigerate_Max.notnull()) | (fkDF.Refrigerate_Max.notnull())]


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
fkDF['Scaled_Metric_DOPRefrigerate'] = fkDF.DOP_Refrigerate_Metric.apply(func_Scale)
fkDF['Scaled_Metric_Refrigerate'] = fkDF.Refrigerate_Metric.apply(func_Scale)

fkDF.DOP_Refrigerate_Max = fkDF.DOP_Refrigerate_Max * fkDF.Scaled_Metric_DOPRefrigerate
fkDF.Refrigerate_Max = fkDF.Refrigerate_Max * fkDF.Scaled_Metric_Refrigerate

fkDF['RefrigerateFinal'] = fkDF.DOP_Refrigerate_Max.fillna(0) + fkDF.Refrigerate_Max.fillna(0)

fkDF = fkDF[['Name', 'Keywords', 'RefrigerateFinal']]

# Get Expiration dates

def getExpiration(inputFood):
    def getfuzz(x):
        return fuzz.token_set_ratio(x, inputFood)

    fkDF['Fuzz_Value'] = fkDF.Keywords.apply(getfuzz)
    finalRows = fkDF[fkDF.Fuzz_Value > 40]
    MaxRow = finalRows.loc[finalRows['Fuzz_Value'].idxmax()]

    return MaxRow['Name'], MaxRow['RefrigerateFinal']


#     return finalRows

#food = 'banana cavendish'
#getExpiration(food)




