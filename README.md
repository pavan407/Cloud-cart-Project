# CloudCart - Team 1 (Python / Django + DRF)

Minimal starter so this team can containerize and deploy to the shared
ECS/ALB pipeline on Day 1-2, then build out real CloudCart features
during the sprint.

## What's here
- Django project (`cloudcart`) with a `products` app
- `GET /health/` - health check for the ALB target group
- `GET /api/products/` and `POST /api/products/` - minimal CRUD starting point
- `Dockerfile` - multi-stage, runs with gunicorn

## Run locally
```
pip install -r requirements.txt
python cloudcart/manage.py migrate
python cloudcart/manage.py runserver
```

## Build & run in Docker
```
docker build -t cloudcart-python .
docker run -p 8000:8000 cloudcart-python
```

## Next steps for the team
- Point `DATABASES` at the shared self-managed EC2 database (read the
  connection string from SSM Parameter Store, not from this file).
- Expand `products/models.py` and `products/views.py` with real
  CloudCart fields (price, stock, category, etc).
- Push the image to ECR and wire it into the shared CI/CD pipeline.
