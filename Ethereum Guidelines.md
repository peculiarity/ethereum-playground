# Eth guidelines. (Work in progress)

In the following sections I will try to describe things that I had problem to deal with and how I actually managed to accomplish them. It's quite interesting how all tutorials and documentation even is outdated easily. This might get outdated as well but at least I will try to update it as frequently as possible.

**Disclaimer: I assume that you have at least installed geth.** - there are plenty of places to read and they are quite accurate. 
Since I'm using _Linux Mint 18_ which is more or less derivative of Ubuntu - here is a link:

[Geth (Go-Ethereum) Installation Guidelines](https://github.com/ethereum/go-ethereum/wiki/Installation-Instructions-for-Ubuntu)


## Setting up private network.

Basically you will need this at least to experiment initially ( how to mine, how to do transactions and send ether to different accounts and etc.) also to verify your smart contracts logic.

In order not to break something on the **main-net** _(1)_ which is under _~/.ethereum_ (at least for linux machines). - create separate folder - i.e. _privnet_ under your home directory.

```
tek@citadel ~ $ mkdir privnet && cd privnet
```

This command will create the folder and get you inside of it once the command is executed.
In order to be more productive, let's open 3 separate terminals.

**It's very important to use the same genesis file for all of the nodes you are about to create**

### 1. Creating Genesis File.

Pick one of the terminal and execute the following command:
```
tek@citadel ~/privnet $ vim Genesis.json
```
Copy/Paste the code below and save. This is sample Genesis file.
```
{
  "nonce": "0x00006d6f7264656e",
  "difficulty": "0x20000",
  "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "timestamp": "0x00",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "extraData": "0x",
  "gasLimit": "0x2FEFD8",
  "alloc": {
    "0000000000000000000000000000000000000001": {
      "balance": "1"
    },
    "0000000000000000000000000000000000000002": {
      "balance": "1"
    },
    "0000000000000000000000000000000000000003": {
      "balance": "1"
    },
    "0000000000000000000000000000000000000004": {
      "balance": "1"
    },
    "102e61f5d8f9bc71d0ad4a084df4e65e05ce0e1c": {
      "balance": "1606938044258990275541962092341162602522202993782792835301376"
    }
  }
}
```
### 2. Creating 'Node One'

In the very same terminal where you created the Genesis file, create a folder for the first node. 

```
tek@citadel ~/privnet $ mkdir node1
```

This will be used as a place where to store all information of node one.

Let's create the chain and put the first block.

```
tek@citadel ~/privnet $ geth --datadir node1/ init Genesis.json 
```

**Note:** Very important to **specify the datadir** because otherwise you will break the **main-net** because commands of this type apply on _~/.ethereum_ where all the data of main-net is stored.

**Another note:** Also important to specify the flag _(datadir)_ before _init Genesis.json_ otherwise an error will be thrown.

Let's light up the first node.
##### 2.1 Starting 'Node One'.

```
tek@citadel ~/privnet $ geth --identity "Node One" --rpc --rpcport "8080" --rpccorsdomain "*" --rpcapi "eth, net, web3" --datadir node1/ --port "30300" --maxpeers 3  --networkid 777 --vmdebug
```
What the flags are you can easily read the documentation or simply execute:

```
geth --help
```

The ones to concentrate are: 
* _--datadir_ - Well as mentioned before, this one is a *MUST* in order not to break something 
* _--identity_ - Identifier of your node. Easy to track on which node you are under console.
* _--rpcport_ - This port with conjuction of your ip address (localhost) form the address for **HTTP-RPC** communication. When create instance of **Web3** you have to provide this whole address so that the WebApp can communicate with the node.
* _--port_ - This is used for the communication between different nodes. It's part of the **ENODE Address**.
* _--networkid_ - Unique ID of the network. All three nodes **MUST** share same networkId. 

Once you light up the node you must see something similar.
```
I0226 21:21:45.075816 cmd/utils/flags.go:613] WARNING: No etherbase set and no accounts found as default
I0226 21:21:45.075918 ethdb/database.go:83] Allotted 128MB cache and 1024 file handles to /home/tek/privnet/node1/geth/chaindata
I0226 21:21:45.100140 ethdb/database.go:176] closed db:/home/tek/privnet/node1/geth/chaindata
I0226 21:21:45.100896 node/node.go:176] instance: Geth/Node One/v1.5.9-stable-a07539fb/linux/go1.7.3
I0226 21:21:45.100921 ethdb/database.go:83] Allotted 128MB cache and 1024 file handles to /home/tek/privnet/node1/geth/chaindata
I0226 21:21:45.118910 eth/db_upgrade.go:346] upgrading db log bloom bins
I0226 21:21:45.119063 eth/db_upgrade.go:354] upgrade completed in 155.886µs
I0226 21:21:45.119096 eth/backend.go:187] Protocol Versions: [63 62], Network Id: 777
I0226 21:21:45.119321 eth/backend.go:215] Chain config: {ChainID: 0 Homestead: <nil> DAO: <nil> DAOSupport: false EIP150: <nil> EIP155: <nil> EIP158: <nil>}
I0226 21:21:45.119727 core/blockchain.go:219] Last header: #0 [c31c0728…] TD=131072
I0226 21:21:45.119748 core/blockchain.go:220] Last block: #0 [c31c0728…] TD=131072
I0226 21:21:45.119759 core/blockchain.go:221] Fast block: #0 [c31c0728…] TD=131072
I0226 21:21:45.120592 p2p/server.go:340] Starting Server
I0226 21:21:47.241397 p2p/discover/udp.go:227] Listening, enode://e16126c135a468767c961c9945d2a21e91be296c89ce391b7da9a92de2c9b0d4f3a7965cfa60dc149656eb3028e66c7fa156bbbd9c53e37e79a3c3540cc1e5f7@[::]:30300
I0226 21:21:47.241609 p2p/server.go:608] Listening on [::]:30300
I0226 21:21:47.244048 node/node.go:341] IPC endpoint opened: /home/tek/privnet/node1/geth.ipc
I0226 21:21:47.244588 node/node.go:411] HTTP endpoint opened: http://localhost:8080
^CI0226 21:22:02.781104 cmd/utils/cmd.go:82] Got interrupt, shutting down...
I0226 21:22:02.781202 node/node.go:427] HTTP endpoint closed: http://localhost:8080
I0226 21:22:02.781283 node/node.go:373] IPC endpoint closed: /home/tek/privnet/node1/geth.ipc
I0226 21:22:02.781306 core/blockchain.go:589] Chain manager stopped
I0226 21:22:02.781321 eth/handler.go:230] Stopping ethereum protocol handler...
I0226 21:22:02.781348 eth/handler.go:251] Ethereum protocol handler stopped
I0226 21:22:02.781411 core/tx_pool.go:196] Transaction pool stopped
I0226 21:22:02.781463 eth/backend.go:519] Automatic pregeneration of ethash DAG OFF (ethash dir: /home/tek/.ethash)
I0226 21:22:02.781646 ethdb/database.go:176] closed db:/home/tek/privnet/node1/geth/chaindata
```

Couple important  parameteres to notice!

* _enode://e16126c135a468767c961c9945d2a21e91be296c89ce391b7da9a92de2c9b0d4f3a7965cfa60dc149656eb3028e66c7fa156bbbd9c53e37e79a3c3540cc1e5f7@[::]:30300_ - this is the unique address of your node instance. It is used to add nodes as peers to a given node. **[::]** - means it's deployed on localhost. 
* _HTTP endpoint opened: http://localhost:8080_ - this is the address to which you connect the **Web3**. By **Web3** I mean when you include web3.js in the browser and you want to develop application. If you pay attention you will see that web3.js is used in the _geth console_ as well.
* _IPC endpoint closed: /home/tek/privnet/node1/geth.ipc_ - used to attach console to this node. **``` geth attach /home/tek/privnet/node1/geth.ipc```** for example.

**Note:** As mentioned before, when no specification is applied, _geth_ command operates over _~/.ethereum_ . That means that if you invoke ```geth attach``` it will attach to _/home/tek/.ethereum/geth.ipc_.

