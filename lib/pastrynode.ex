defmodule PastryNode do
    use GenServer
    def start_link(x,nodes,numRequests) do
    b=4
    input_srt = Integer.to_string(x)
    nodeid = String.slice(Base.encode16(:crypto.hash(:sha256, input_srt)),32,32)
    GenServer.start_link(__MODULE__, {nodeid,b,nodes,numRequests}, name: String.to_atom(nodeid))    
    end

    def init({nodeid,b,nodes,numRequests}) do
        {:ok, {nodeid,[],{},numRequests}}
    end

    def handle_cast({:route,key},{nodeid,leaf,routetable,req})do
        #compute difference between self and key



        #check leaf set

        
        {:noreply,{nodeid,leaf,routetable,req}}
    end

end