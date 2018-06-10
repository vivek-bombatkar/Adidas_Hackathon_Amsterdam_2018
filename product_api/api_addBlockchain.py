
from aiohttp import web
import json
import blockchain.interfaceBC as interfaceBC


app = web.Application()
app.router.add_get('/addBlockchain', interfaceBC.addBlockchain)

web.run_app(app)