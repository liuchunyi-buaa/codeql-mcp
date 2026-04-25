FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 安装最低运行依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        tar \
    && rm -rf /var/lib/apt/lists/*

# 下载并安装 CodeQL CLI
RUN apt-get update && apt-get install -y wget && \
    wget -q -O /tmp/codeql.tar.gz \
        https://github.com/github/codeql-cli-binaries/releases/download/v2.18.0/codeql-linux64.zip && \
    apt-get install -y unzip && \
    unzip /tmp/codeql.tar.gz -d /opt && \
    ln -s /opt/codeql/codeql /usr/local/bin/codeql && \
    rm /tmp/codeql.tar.gz && \
    apt-get remove -y wget unzip && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "server.py"]
