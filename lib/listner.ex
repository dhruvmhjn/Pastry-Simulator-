defmodule Listner do
    use GenServer
    def start_link(numnodes,numrequests) do
        myname = String.to_atom("listner")
        return = GenServer.start_link(__MODULE__, {numnodes,numrequests}, name: myname )
        return
    end
    
    def init({numnodes,numrequests}) do
        {:ok,{numrequests,numnodes,0,0,0}}
    end

    def handle_cast({:stated_s,lastnodeid},{numrequests,numnodes,numstarted,hop_counter,hop_msgs_recieved}) do
        numstarted = numstarted+1
        if numnodes > numstarted do
            IO.puts "num in ring: #{numstarted}"
            nextnode = "n"<>String.slice(Base.encode16(:crypto.hash(:sha256, Integer.to_string(numstarted+1) ) ),32,32)
            # ADD INIT NEXT cast here 
            GenServer.cast(String.to_atom(nextnode),{:intialize_table,lastnodeid})
        else 
            send(Process.whereis(:boss),{:network_ring_created})
        end
        {:noreply,{numrequests,numnodes,numstarted,hop_counter,hop_msgs_recieved}}
    end

    def handle_cast({:delivery,no_of_hops},{numrequests,numnodes,numstarted,hop_counter,hop_msgs_recieved}) do
        hop_msgs_recieved = hop_msgs_recieved +1
        if(hop_msgs_recieved <= (numrequests*numnodes)) do
            hop_counter = hop_counter + no_of_hops
        
        else
            send(Process.whereis(:boss),{:all_requersts_served,hop_counter}
        end
    end
end