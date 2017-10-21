defmodule PastryNode do
    use GenServer
    def start_link(x,nodes,numRequests) do
    b=4
    input_srt = Integer.to_string(x)
    nodeid = String.slice(Base.encode16(:crypto.hash(:sha256, input_srt)),32,32)
    GenServer.start_link(__MODULE__, {nodeid,b,nodes,numRequests}, name: String.to_atom("n#{nodeid}"))    
    end

    def init({nodeid,b,nodes,numRequests}) do
        {:ok, {nodeid,[],{},numRequests}}
    end

   
    def handle_cast({:route,key},{nodeid,leaf,routetable,req})do
        #compute difference between leafset and key
        {keyval,_} = Integer.parse(key,16)

        #check leaf set
        {firstlist,_} = Integer.parse(to_string(List.first(leaf)),16)
        {lastleaf,_} = Integer.parse(to_string(List.last(leaf)),16)

        if(keyval >= firstleaf) &&(keyval <= lastleaf) do
            
        end
        


        
        {:noreply,{nodeid,leaf,routetable,req}}
    end

end