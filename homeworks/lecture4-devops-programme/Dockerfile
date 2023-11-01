FROM ubuntu:22.04
RUN useradd -u 1001 testuser
RUN apt-get update \
    && apt-get install python3 python3-pip -y \
    && mkdir /app/ \
    && mkdir /req/
ADD requirements.txt /req/
RUN pip install -r /req/requirements.txt
ADD app /app
EXPOSE 5000
# Use this user here, because of permissions
USER testuser
ENTRYPOINT ["python3"]
CMD ["/app/app.py"]