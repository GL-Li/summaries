import os

# Read Docker secret or fallback to local .env file
try:
    # secure api key in docker compose secret
    with open('/run/secrets/api_keys_env', 'r') as f:
        for line in f:
            if line.strip() and not line.startswith('#'):
                key, value = line.strip().split('=', 1)
                os.environ[key] = value
except FileNotFoundError:
    # Fallback for local development
    from dotenv import load_dotenv
    load_dotenv("api-keys/.env")

from langchain.chat_models import init_chat_model
llm = init_chat_model(model="gpt-4o-mini", model_provider="openai")

def test_chat(query: str):
    response = llm.invoke(query)
    return response.content

if __name__ == "__main__":
    print("OpenAI Chat Bot - Type 'quit' or 'exit' to exit")
    print("=" * 40)
    
    while True:
        try:
            print("")
            print("-" * 20)
            query = input("User: ")
            if query.lower() in ['quit', 'exit', 'q']:
                print("Goodbye!")
                break
            
            if query.strip():
                print("\nAssistant: ", end="", flush=True)
                response = test_chat(query)
                print(response)
            else:
                print("Please enter a question or type 'quit' to exit.")
                
        except KeyboardInterrupt:
            print("\nGoodbye!")
            break
        except EOFError:
            print("\nGoodbye!")
            break
        except Exception as e:
            print(f"Error: {e}")
