from dotenv import load_dotenv
load_dotenv("api-keys/.env")

from langchain.chat_models import init_chat_model
llm = init_chat_model(model="gpt-4o-mini", model_provider="openai")

def test_chat(query: str):
    response = llm.invoke(query)
    return response.content

if __name__ == "__main__":
    query = input("User: ")
    anw = test_chat(query)
    print(anw)
