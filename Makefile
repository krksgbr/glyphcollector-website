
sources = $(shell find $(1) -type f)

node_modules:
	@yarn

build: \
	node_modules \
	$(call sources, $(PWD)/public) \
	$(call sources, $(PWD)/src)
	@elm-app build

deploy: \
	build
	@netlify deploy --dir build --prod

dev: node_modules
	@elm-app start
