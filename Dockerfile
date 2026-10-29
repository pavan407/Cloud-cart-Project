# ---- build stage ----
FROM python:3.12-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- runtime stage ----
FROM python:3.12-slim
WORKDIR /app
COPY --from=build /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=build /usr/local/bin /usr/local/bin
COPY cloudcart /app/cloudcart
WORKDIR /app/cloudcart
EXPOSE 8000
CMD ["gunicorn", "cloudcart.wsgi:application", "--bind", "0.0.0.0:8000"]
