import blockChain as blockChain
import csv

def initBlockchain(csvPath):
    #if valide path
    #split values and add to bc
    with open(csvPath) as readCsv:
        productCsv = csv.reader(readCsv,delimiter=',')
        for row in productCsv:
            for col in row:
                prev_block = bc[len(bc) - 1]
                new_block = blockChain.getNextBlock(prev_block, col)
                bc.append(new_block)
    return True

def getPrductHistory(txID):
    return []

if __name__ == '__main__':
    filePath = r'C:\VIVEK\GIT\Adidas_Amsterdam_2018\row_data\productData_1.csv'
    bc = [blockChain.getGenesisBlock()]
    initBlockchain(filePath)
    for block in bc:
        print(block)
