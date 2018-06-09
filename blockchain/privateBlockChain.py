import datetime as date
import hashlib as hash

class Block:
    def __init__(self, Transaction_ID, timestamp, data, prev_hash):
        self.Transaction_ID = Transaction_ID
        self.timestamp = timestamp
        self.data = data
        self.prev_hash = prev_hash
        self.hash = hash.sha256(str(data).encode('ascii')).hexdigest()

    def __repr__(self):
        return "{0} : {1}, {2}, {3} ".format(self.Transaction_ID, str(self.timestamp), self.data,self.prev_hash)

def getGenesisBlock():
    return Block('8f6b7d0d-ca32-4598-8a60-9a1852d0aa32_'+str(0), date.datetime.now(), "the genesis block", "0")
#8f6b7d0d-ca32-4598-8a60-9a1852d0aa32
def getNextBlock(prev_block, data):
    Transaction_ID = prev_block.Transaction_ID.split('_')[0] + '_' + str(int(prev_block.Transaction_ID.split("_")[-1]) + 1)
    timestamp = date.datetime.now()
    data = data
    hash = prev_block.hash
    return Block(Transaction_ID, timestamp, data, hash)

def validateTransactionID(TxID, bc):
    for block in bc:
        if str(block.Transaction_ID) == str(TxID).strip():
            return True
    return False

    