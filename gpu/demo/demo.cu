#include <algorithm>
#include <iostream>
#include <cassert>
#include <cmath>
#include <chrono>

using namespace std;

#define TIMER_SET(t0) std::chrono::time_point<std::chrono::steady_clock> t0 = std::chrono::steady_clock::now()
#define TIMER_DIFF(t0, t1) std::chrono::duration_cast<std::chrono::microseconds> (t1 - t0).count()

__global__
void kernel(float * A, int N) {
  int id = blockIdx.x * blockDim.x + threadIdx.x;
  if (id >= N) return;
  A[id] = sqrtf( powf(3.1415926f, id) );
}

int main(int argc, char * argv[]) {
  const int N = 10000000;
  float * A;

  TIMER_SET(t0);

#ifdef CPU_DEMO
  A = new float[N];
#else
  cudaMallocManaged(&A, sizeof(float) * N, cudaMemAttachGlobal);
#endif

  // Calculate A[i] = sqrt( pow(PI, i) ) (add two vectors)
#ifdef CPU_DEMO
  for (int i = 0; i < N; ++i) {
    A[i] = sqrtf( powf(3.1415926f, i) );
  }
#else
  int dimBlock = 64;
  int dimGrid = (N + dimBlock - 1) / dimBlock;
  kernel<<<dimGrid, dimBlock>>>(A, N);
  cudaDeviceSynchronize();
#endif

  // for (int i = 0; i < 5; ++i) {
  //   cout << ' ' << A[i];
  // }
  // cout << endl;

  TIMER_SET(t1);
  cout << "Time (microsecond): " << TIMER_DIFF(t0, t1) << endl;

#ifdef CPU_DEMO
  delete A;
#else
  cudaFree(A);
#endif

  return 0;
}
