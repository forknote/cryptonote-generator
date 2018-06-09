cmake-release:
	mkdir -p build
	cd build && cmake -DUSE_SSL=0 ..

build-release: cmake-release
	cd build && $(MAKE)

clean:
	rm -rf build

.PHONY: cmake-release build-release clean
