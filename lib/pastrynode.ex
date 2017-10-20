defmodule PastryNode do
    use GenServer
    def start_link(x,numRequests) do
    b=4
    input_srt = Integer.to_string(x)
    nodeid = String.slice(Base.encode16(:crypto.hash(:sha256, input_srt)),32,32)
    GenServer.start_link(__MODULE__, {nodeid,b,numRequests}, name: String.to_atom(nodeid))    
    end

    

end