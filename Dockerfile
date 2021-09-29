FROM python:3.9
USER root

RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

RUN apt-get install -y vim less libboost-dev swig build-essential cmake git
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install scikit-build matplotlib scipy numpy cython ninja autopep8

RUN git clone https://github.com/dwavesystems/dwave-preprocessing.git
WORKDIR /dwave-preprocessing
RUN pip install -r requirements.txt
RUN python setup.py build_ext --inplace
RUN python setup.py install
WORKDIR /

RUN git clone https://github.com/dwavesystems/dwave-ocean-sdk.git
WORKDIR /dwave-ocean-sdk
RUN python3 setup.py build
RUN python3 setup.py install

RUN echo \
    ""$CONFIGURATION_FILE_PATH"$'\n'\
    "y"$'\n'\
    "$PROFILE_NAME"$'\n'\
    "$ENDPOINT"$'\n'\
    "$TOKEN"$'\n'\
    "$DEFEAULT_CLIENT_CLASS"$'\n'\
    "$DEFEAULT_SOLVER"$'\n'"\
    | dwave setup --install-all
RUN dwave install inspector