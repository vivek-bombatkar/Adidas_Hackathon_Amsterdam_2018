from aiohttp import web
import os, sys
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.dirname(CURRENT_DIR))
import blockchain.interface_blockchain as interfaceBC

app = web.Application()
app.router.add_post('/product-records', interfaceBC.addBlockchain)
app.router.add_get('/product-records', interfaceBC.getPrductHistory)

web.run_app(app,port=8083)