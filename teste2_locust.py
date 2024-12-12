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