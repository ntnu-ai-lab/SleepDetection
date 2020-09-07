# Use standard python image
FROM python:3.6.3

# All data goes inside /hunt4_sleep
WORKDIR /hunt4_sleep

# Install pip dependencies
COPY requirements.txt /tmp/requirements.txt
# Hack to get the dependencies right.
RUN pip install numpy==1.16.4 scipy==1.0.0 && \
    pip install -r /tmp/requirements.txt

# Add volume for user dat a
VOLUME /hunt4_sleep/user

# Add entrypoint that creates user matching host machine
COPY scripts/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]

# Copy over built-in notebooks
COPY notebooks /hunt4_sleep/notebooks

# Default start command
CMD ["jupyter-lab", "--allow-root", "--no-browser", \
                    "--ip", "0.0.0.0", "--port", "8888", \
                    "--notebook-dir=/hunt4_sleep", "--NotebookApp.token=''", \
                    "--NotebookApp.password=''"]
