defmodule Listner do
    use GenServer
    def start_link(numnodes,numrequests) do
        myname = String.to_atom("listner")
        return = GenServer.start_link(__MODULE__, {numnodes,numrequests}, name: myname )
        return
    end
    
    def init({numnodes,numrequests}) do
        {:ok,{numrequests,numnodes,0}}
    end

    def handle_cast({:stated_s,lastnodeid},{numrequests,numnodes,numstarted}) do
        numstarted = numstarted +1
        if numnodes > numstarted do
            nextnode = "n"<>String.slice(Base.encode16(:crypto.hash(:sha256, Integer.to_string(numstarted+1) ) ),32,32)
            # ADD INIT NEXT cast here 
            Genserver.cast(String.to_atom(nextnode),{:intialize_table,lastnodeid})
        else 
            send(Process.whereis(:boss),{:network_ring_created})
        end

    end

    def handle_cast(:heardrumour,{numrequests,numnodes,numstated})do
        newcount=count+1 
        #IO.puts "#{newcount} node/s have heard the rumour."
        if newcount == numnodes do
            b = System.system_time(:millisecond)
            IO.puts "Rumour Propogated, Terminating."
            send(Process.whereis(:boss),{:rumourpropogated,b})
            #s:init.stop
            #OR Supervisor.stop(sup)
        end
        {:noreply,{newcount,numnodes}}
    end

end