from locust import HttpUser, TaskSet, task

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

    