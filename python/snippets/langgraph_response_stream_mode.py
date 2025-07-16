from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, BaseMessage
from langgraph.graph.message import add_messages
from langgraph.graph import START, END, StateGraph
from langgraph.checkpoint.memory import InMemorySaver
from typing import TypedDict, Sequence, Annotated
from dotenv import load_dotenv
load_dotenv()

llm = ChatOpenAI(model="gpt-4o-mini")

class State(TypedDict):
    messages: Annotated[Sequence[BaseMessage], add_messages]

def response_node(state: State) -> dict:
    response = llm.invoke(state['messages'])
    return {'messages': response}

builder = StateGraph(state_schema=State)
builder.add_node("response", response_node)
builder.add_edge(START, "response")
builder.add_edge("response", END)
app = builder.compile(checkpointer=InMemorySaver())

config = {"configurable": {"thread_id": "abc123"}}

while True:
    print("\n\n=========================")
    query = input("You: ")
    if query == "q":
        break

    print("\nAI:")
    for chunk, _ in app.stream(
        input={"messages": HumanMessage(content=query)},
        config=config,
        stream_mode="messages"
    ):
        print(chunk.content, end="")

