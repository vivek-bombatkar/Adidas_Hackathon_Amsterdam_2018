#import blockChain as blockChain
import privateBlockChain as blockChain
import csv

def initBlockchain(csvPath):
    #if valide path
    #split values and add to bc
    with open(csvPath) as readCsv:
        productCsv = csv.reader((line.replace('},{', '#' ) for line in  readCsv),delimiter='#')
        for row in productCsv:
            for col in row:
                prev_block = bc[len(bc) - 1]
                new_block = blockChain.getNextBlock(prev_block, "{{{}}}".format(col))
                bc.append(new_block)
    return True

def getPrductHistory(txID):
    result = []
    if blockChain.validateTransactionID(txID,bc):
        # TODO: returining the entire bc !!!
        for block in bc:
          result.append(block.data)
    else:
        return []
    return result

def addBlockchain(txID,data):
    if blockChain.validateTransactionID(txID,bc):
        prev_block = bc[len(bc) - 1]
        new_block = blockChain.getNextBlock(prev_block, data)
        bc.append(new_block)
    else:
        return False

    return True

if __name__ == '__main__':
    filePath = r'C:\VIVEK\GIT\Adidas_Amsterdam_2018\row_data\productData_1.csv'
    bc = [blockChain.getGenesisBlock()]
    initBlockchain(filePath)

    addBlockchain(0,'{"Name": "Powerlift.3.1 Shoes","From": "Vanya Kostova, Nuremberg, Germany","Transferred to": "Tiago, Portugal"}')
'''
    addBlockchain(0,'owner_2:vivek')
    print(getPrductHistory(1))

'''

for item in getPrductHistory(1):
    print("#" * 10)
    print(item)