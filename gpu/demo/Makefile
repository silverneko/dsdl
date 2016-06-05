CXX = nvcc
CXXFLAGS = -std=c++11 -O2 -arch=sm_30

all:
	$(CXX) $(CXXFLAGS) -DCPU_DEMO -o demo_cpu demo.cu
	$(CXX) $(CXXFLAGS) -o demo_gpu demo.cu
	$(CXX) $(CXXFLAGS) -use_fast_math -o demo_gpu_fast_math demo.cu

run:
	./demo_cpu
	./demo_gpu
	./demo_gpu_fast_math

clean:
	rm -rf demo_cpu demo_gpu demo_gpu_fast_math
