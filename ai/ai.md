## Langchain-langgraph-langsmith

### QA: how to draw a graph on terminal

```python
# graph = graph_builder.compile()
graph.get_graph().print_ascii()
# the graph is printed on terminal like
#           +-----------+      
#           | __start__ |      
#           +-----------+      
#                 *            
#                 *            
#                 *            
#       +------------------+   
#       | query_or_respond |   
#       +------------------+   
#            ..        ..      
#          ..            ..    
#         .                ..  
#   +-------+                . 
#   | tools |                . 
#   +-------+                . 
#       *                    . 
#       *                    . 
#       *                    . 
# +----------+               . 
# | generate |             ..  
# +----------+           ..    
#            **        ..      
#              **    ..        
#                *  .          
#            +---------+       
#            | __end__ |       
#            +---------+  
```
