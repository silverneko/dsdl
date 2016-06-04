#include <algorithm>
#include <iostream>
#include <cassert>
#include <cmath>

using namespace std;

__global__
void kernel1(int * A, int * B, int N) {
  int id = blockIdx.x * blockDim.x + threadIdx.x;
  if (id >= N) return;
  A[id] += B[id];
}

int main(int argc, char * argv[]) {
  const int N = 10000;
  int * A, * B;

  // A = new int[N];
  // B = new int[N];
  cudaMallocManaged(&A, sizeof(int) * N, cudaMemAttachGlobal);
  cudaMallocManaged(&B, sizeof(int) * N, cudaMemAttachGlobal);

  // Do something with A and B ...

  // Calculate A = A + B (add two vectors)
  int dimBlock = 32;
  int dimGrid = N / 32 + 1;
  kernel1<<<dimGrid, dimBlock>>>(A, B, N);
  cudaDeviceSynchronize();

  // for (int i = 0; i < N; ++i) {
  //   A[i] += B[i];
  // }

  cudaFree(A);
  cudaFree(B);
  return 0;
}
