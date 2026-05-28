ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION:-3.8}
WORKDIR /app 
COPY . .
RUN pip install -r requirements.txt
ARG AUTHOR
LABEL author=${AUTHOR}
LABEL version="1"
LABEL description="an app"
ENV YOUR_NAME="Dave"
EXPOSE 5500
ENTRYPOINT [ "python", "app.py" ]