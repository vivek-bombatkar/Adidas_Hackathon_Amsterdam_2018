#import blockChain as blockChain
from blockchain import privateBlockChain as blockChain
import pandas as pd

def getPrductHistory(txID):
    result = []
    if blockChain.validateTransactionID(txID,bc):
        # TODO: returining the entire bc !!!
        for block in bc:
          result.append("{},{}".format(block.timestamp,block.data))
    else:
        print("invalide block")
        return []
    return result

def initBlockchain(csvPath):

    print(csvPath)
    productCsv = pd.read_csv(csvPath,sep='},{',engine='python')
#csv.reader((line.replace('},{', '#' ) for line in  csvPath),delimiter='#')
    for row in productCsv:
#        for col in row:
        prev_block = bc[len(bc) - 1]
        new_block = blockChain.getNextBlock(prev_block, "{{{}}}".format(row))
        bc.append(new_block)
    return True

def addBlockchain(data):
    prev_block = bc[len(bc) - 1]
    new_block = blockChain.getNextBlock(prev_block, data)
    bc.append(new_block)
    return True

if __name__ == '__main__':
    filePath = 'https://raw.githubusercontent.com/vivek-bombatkar/Adidas_Amsterdam_2018/master/row_data/productData_1.csv'
    #response = urllib2.urlopen(filePath)
    bc = [blockChain.getGenesisBlock()]
    initBlockchain(filePath)
    #print(bc)

    addBlockchain('{"Name": "Powerlift.3.1 Shoes","From": "Vanya Kostova, Nuremberg, Germany","Transferred to": "Tiago, Portugal"}')


    for item in getPrductHistory('8f6b7d0d-ca32-4598-8a60-9a1852d0aa32_0'):
        print("#" * 10)
        print(item)

