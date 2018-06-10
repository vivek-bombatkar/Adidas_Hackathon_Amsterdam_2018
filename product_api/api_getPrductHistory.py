
from aiohttp import web
import json
import blockchain.interfaceBC as interfaceBC


app = web.Application()
app.router.add_get('/getPrductHistory', interfaceBC.getPrductHistory)

web.run_app(app)