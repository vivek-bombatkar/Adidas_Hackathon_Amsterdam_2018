from blockchain import privateBlockChain as blockChain
import pandas as pd
from aiohttp import web
import json

def initBlockchain():
    filePath = 'https://raw.githubusercontent.com/vivek-bombatkar/Adidas_Amsterdam_2018/master/row_data/productData_1.csv'
    bc = [blockChain.getGenesisBlock()]
    productCsv = pd.read_csv(filePath,sep='},{',engine='python')
#csv.reader((line.replace('},{', '#' ) for line in  csvPath),delimiter='#')
    for row in productCsv:
#        for col in row:
        prev_block = bc[len(bc) - 1]
        new_block = blockChain.getNextBlock(prev_block, "{{{}}}".format(row))
        bc.append(new_block)
    return bc

def getPrductHistory(txID):
    bc = initBlockchain()
    result = []
    for block in bc:
      result.append("{},{}".format(block.timestamp,block.data))
    return web.Response(text=json.dumps(result))

def addBlockchain(request):
    bc = initBlockchain()
    prev_block = bc[len(bc) - 1]
    data = request.query['name']
    new_block = blockChain.getNextBlock(prev_block, data)
    bc.append(new_block)
    result = []
    for block in bc:
      result.append("{},{}".format(block.timestamp,block.data))
    return web.Response(text=json.dumps(result))
