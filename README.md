# Project-3
Reference:
  matrix.ex is a module avalaibe on the internet which provides a 2-D array implematation for elixir.
  This is used in the project to store and easily access Route tables in pastry nodes.

  Code avalaible at: http://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir.html
  Author: Daniel K.
  Used by: Dhruv Mahajan, Ashvini Patel.
  


What is working:
  Implemented the full project brief. 
  The pastry network configuration constants are as follows:
  
  b=4 i.e. node id's are in base 16 (2^b)
  l=32 i.e size of leaf set
  The routing table has 16 columns with upto 32 rows.
  md5 algoritm used to generate 128 bit node id's and request keys. 
  
  Input/Output
  Input format is the same as specified. (./project3 numNodes numrequests )
  We output 3 lines for each run. First to indicate Node spawning. After which each node joins the network sequentially. So, this step may take some time.
  For a network of 10,000 nodes, this takes approximately 5-mins.

  Next console output indicates that all nodes have joined and the pastry network is created. After this each node genetrates 1 request per second. So, for 100 requests, this  step will take atleast 100 seconds.

  Lastly, we output the Total hop count and the Average Hop count.

  Observed values of AVG Hop count

  No. of Nodes  No. of Requests   Avg. count
  10            30                0.9
  100           30                1.55
  1,000         10                2.3
  10,000        10                3.03
  50,000        5                 3.64

Largest network: 50,000 pastry nodes sending 10 requests each. This is beacuse of memory limitation on the systems avaliabe (16GB). If a machine with more memory is avaliable, this code can scale to many more nodes.
