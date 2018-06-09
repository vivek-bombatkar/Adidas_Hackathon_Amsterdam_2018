
from aiohttp import web
import json
from blockchain import interfaceBC

async def handle(request):
    response_obj = { 'status' : 'vivek' }
    return web.Response(text=json.dumps(response_obj))

async def new_user(request):
    try:
        # happy path where name is set
        user = request.query['name']
        # Process our new user
        print("Creating new user with name: ", user)

        response_obj = {'status': user + ' success'}
        # return a success json response with status code 200 i.e. 'OK'
        return web.Response(text=json.dumps(response_obj), status=200)
    except Exception as e:
        # Bad path where name is not set
        response_obj = {'status': 'failed', 'reason': str(e)}
        # return failed with a status code of 500 i.e. 'Server Error'
        return web.Response(text=json.dumps(response_obj), status=500)

app = web.Application()
app.router.add_get('/getPrductHistory', interfaceBC.getPrductHistory)
#'8f6b7d0d-ca32-4598-8a60-9a1852d0aa32_0'
#app.router.add_get('/addBlockchain', new_user)
                   #'{"Name": "Powerlift.3.1 Shoes","From": "Vanya Kostova, Nuremberg, Germany","Transferred to": "Tiago, Portugal"}')

web.run_app(app)