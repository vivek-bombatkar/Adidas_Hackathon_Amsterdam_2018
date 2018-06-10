
import json
import pandas as pd
from aiohttp import web
from blockchain import private_blockchain as blockChain


def initBlockchain():
    #hardcoded path, this is just because it is provate implementation of blockchain
    filePath = 'https://raw.githubusercontent.com/vivek-bombatkar/Adidas_Amsterdam_2018/master/row_data/productData_1.csv'
    bc = [blockChain.getGenesisBlock()]
    productCsv = pd.read_csv(filePath,sep='},{',engine='python')
    for row in productCsv:
        prev_block = bc[len(bc) - 1]
        new_block = blockChain.getNextBlock(prev_block, "{{{}}}".format(row))
        bc.append(new_block)
    return bc

def getPrductHistory(txID):
    try:
        bc = initBlockchain()
        result = []
        for block in bc:
          result.append("{},{}".format(block.timestamp,block.data))
        return web.Response(text=json.dumps(result))
    except Exception as e:
        # Bad path where name is not set
        response_obj = {'status': 'failed', 'reason': str(e)}
        # return failed with a status code of 500 i.e. 'Server Error'
        return web.Response(text=json.dumps(response_obj), status=500)

async def addBlockchain(request):
    try:
        bc = initBlockchain()
        prev_block = bc[len(bc) - 1]
        data = await request.json()
        new_block = blockChain.getNextBlock(prev_block, str(data))
        bc.append(new_block)
        result = []
        for block in bc:
          result.append("{},{}".format(block.timestamp,block.data))
        return web.Response(text=json.dumps(result))
    except Exception as e:
        # Bad path where name is not set
        response_obj = {'status': 'failed', 'reason': str(e)}
        # return failed with a status code of 500 i.e. 'Server Error'
        return web.Response(text=json.dumps(response_obj), status=500)