
from aiohttp import web
import json
import os, sys
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.dirname(CURRENT_DIR))
import blockchain.interfaceBC as interfaceBC


app = web.Application()
app.router.add_get('/getPrductHistory', interfaceBC.getPrductHistory)

web.run_app(app)