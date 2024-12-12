[TESTE 1] - Testes básicos de GET e POST

# Importação das classes a partir do Locust
from locust import HttpUser, TaskSet, task

# Classe TaskSet: Coleção de tarefas
# Classe HttpUser: uma classe que utiliza uma lib do python, conhecida como requests, que permite utilizar todos os verbos Http, pra simular uma requisição Http
# Classe task: decorador de task, você precisa desse decorador pra que o teste seja executado

# Requisições com status_code abaixo de 400, o locust entende como sucesso

class UserRouteLoadTest(TaskSet):

    @task()
    def test_list_users(self):
        self.client.get("/usuarios", name="Listar os usuários")

    @task()
    def test_create_users(self):
        self.client.post(
            "/usuarios", 
            name="Criar os usuários",
            json={
                "nome": "cleiton",
                "email": "cleiton@hotmail.com",
                "password": "teste",
                "administrator": "false"
            }
        )

class WebsiteUser(HttpUser):
    tasks = [
        UserRouteLoadTest
    ]

[TESTE 2] - Executando o Locust com LoadTestShape

# LoadTestShape ajuda a criar testes com estágios de execução

from locust import HttpUser, LoadTestShape

from teste_locust import UserRouteLoadTest

class WebsiteUser(HttpUser):
    tasks = [
        UserRouteLoadTest
    ]

class StageShape(LoadTestShape):
    stage = [
        {"duration": 5, "users": 10, "spawn_rate": 1},
        {"duration": 10, "users": 10, "spawn_rate": 2},
    ]

    def tick(self):
        run_time = self.get_run_time()

        for stage in self.stage:
            if run_time < stage["duration"]:
                tick_data = (stage["users"], stage["spawn_rate"])
                return tick_data