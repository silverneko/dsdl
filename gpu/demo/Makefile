CXX = nvcc
CXXFLAGS = -std=c++11 -O2 -arch=sm_30

demo: demo.cu
	$(CXX) $(CXXFLAGS) -o demo demo.cu

clean:
	rm -rf demo
