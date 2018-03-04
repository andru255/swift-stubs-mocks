all: clean build run

build:
	./run-container.sh swift build
run:
	./run-container.sh swift run
clean:
	rm -fr .build Package.resolved .lldb
test:
	./run-container.sh swift test

