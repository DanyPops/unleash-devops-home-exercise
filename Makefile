build:
	npm run build

exec: build
	./validate-env.sh
	node dist/index.js
