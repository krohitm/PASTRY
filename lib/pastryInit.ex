defmodule PastryInit do
@b 4
use GenServer
  #spawning actors
  def pastryInit(_, 0) do
    true
  end
  def pastryInit(numNodes) do
    newNode = spawnProcess(numNodes)
    newNode |> pastryInit(numNodes-1)
  end
  def pastryInit(nearbyNode, numNodes) do
    newNode = spawnProcess(numNodes)
    sendJoin(newNode, nearbyNode)
    newNode |> pastryInit(numNodes-1)
  end

  def spawnProcess(nodeCounter) do
    nodeId = :md5
            |> :crypto.hash(to_string(nodeCounter)) 
            |> Base.encode16() 
            |> String.to_atom
    #initialize states
    leafSet = []#States.initLeafSet(@b)
    routingTable = %{}#States.initRoutingTable(@b)
    neighborSet = []#States.initNeighborsSet(@b)
    {:ok, pid} = GenServer.start(__MODULE__, {leafSet, routingTable, neighborSet}, name: nodeId)
    #nodeId = :md5 |> :crypto.hash(:erlang.pid_to_list(pid)) |> Base.encode16() 
    :global.register_name(nodeId, pid)
    newNode = nodeId
  end

  def init(state) do
    {:ok, state}
  end

  #new node sends join to nearest node
  def sendJoin(newNode, nearbyNode) do
    #IO.inspect :global.registered_names
    GenServer.cast(newNode, {:joinNetwork, nearbyNode, newNode})
  end

  #new node sends :join message to "assumed" nearby node
  def handle_cast({:joinNetwork, nearbyNode, newNode}, curState) do
    GenServer.cast(nearbyNode, {:join, newNode})
    { :noreply, curState}
  end
  #nearby node selected by the new node receives the join message
  def handle_cast({:join, key}, curState) do
    { :noreply, curState}
  end
  #send request form this node
  def handle_cast(:sendRequest, curState) do
    key =  2 * :math.pow(2,@b) |> round |> Utils.perm_rep
    PastryRoute.route(key, curState)
    {:noreply, curState}
  end
  #receive the message as the final node
  def handle_cast({:finalNode, message}, curState) do
    {:noreply, curState}
  end
end