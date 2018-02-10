.PHONY: docs venv nodeenv

PYTHON=/usr/bin/python3
VENV=${PWD}/venv
VENV_PY=$(VENV)/bin/python
VENV_PIP=$(VENV)/bin/pip
VENV_ACT=$(VENV)/bin/activate

all: setup

setup: venv nodeenv node_modules

backend: $(VENV_ACT)
	$(VENV_PY) run.py

# virtualenv
venv: $(VENV_ACT)
$(VENV_ACT): requirements.txt
	test -d $(VENV) || virtualenv -p $(PYTHON) $(VENV)
	$(VENV_PIP) install -Ur requirements.txt
	touch $@

# Install nodeJS
nodeenv: $(VENV)/bin/npm
$(VENV)/bin/npm: $(VENV_ACT)
	$(VENV)/bin/nodeenv --python-virtualenv
	touch  $@

node_modules: node_modules/.touch
node_modules/.touch: $(VENV)/bin/npm package.json
	bash -c "source $(VENV_ACT); \
	$(VENV)/bin/npm install"
	touch $@

web: web/package-lock.json
web/package-lock.json: $(VENV)/bin/npm
	bash -c "source $(VENV_ACT); \
		cd web; \
		$(VENV)/bin/npm install"

web-serve: web/package-lock.json
	bash -c "source $(VENV_ACT); \
		cd web; \
		$(VENV)/bin/npm start"

clean: 
distclean: clean
	rm -rf $(VENV) node_modules docs package-lock.json
	rm -rf web/node_modules/ web/package-lock.json 

docs: $(VENV_ACT)
	bash -c "source $(VENV_ACT); \
	$(MAKE) -C docs html" 
