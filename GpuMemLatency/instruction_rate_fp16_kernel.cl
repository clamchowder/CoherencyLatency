#define rate_local_mem_test_size 256
__kernel void fp16_add_rate_test(__global half8 *A, int count, __global half8 *ret) {
    int tid = get_local_id(0);
    int max_offset = get_local_size(0);
    __global half8 *local_a = A;

    int masked_tid = tid & (rate_local_mem_test_size - 1);
    half8 v0 = local_a[masked_tid];
    half8 v1 = local_a[masked_tid + 1];
    half8 v2 = local_a[masked_tid + 2];
    half8 v3 = local_a[masked_tid + 3];
    half8 v4 = v0 + v1;
    half8 v5 = v0 + v2;
    half8 v6 = v0 + v3;
    half8 v7 = v1 + v2;
    half8 acc = local_a[0];

    for (int i = 0; i < count; i++) {
        v0 += acc;
        v1 += acc;
        v2 += acc;
        v3 += acc;
        v4 += acc;
        v5 += acc;
        v6 += acc;
        v7 += acc;
    }

    ret[get_global_id(0)] = v0 + v1 + v2 + v3 + v4 + v5 + v6 + v7;
}

__kernel void fp16_fma_rate_test(__global half8 *A, int count, __global half8 *ret) {
    int tid = get_local_id(0);
    int max_offset = get_local_size(0);
    __global half8 *local_a = A;

    int masked_tid = tid & (rate_local_mem_test_size - 1);
    half8 v0 = local_a[masked_tid];
    half8 v1 = local_a[masked_tid + 1];
    half8 v2 = local_a[masked_tid + 2];
    half8 v3 = local_a[masked_tid + 3];
    half8 v4 = v0 + v1;
    half8 v5 = v0 + v2;
    half8 v6 = v0 + v3;
    half8 v7 = v1 + v2;
    half8 acc = local_a[0];

    for (int i = 0; i < count; i++) {
        v0 += acc * v0;
        v1 += acc * v1;
        v2 += acc * v2;
        v3 += acc * v3;
        v4 += acc * v4;
        v5 += acc * v5;
        v6 += acc * v6;
        v7 += acc * v7;
    }

    ret[get_global_id(0)] = v0 + v1 + v2 + v3 + v4 + v5 + v6 + v7;
}

__kernel void fp16_dot_rate_test(__global half4 *A, int count, __global float *ret) {
    int tid = get_local_id(0);
    int max_offset = get_local_size(0);
    __global half4 *local_a = A;

    float d0 = 0.1f, d1 = 0.2f, d2 = 0.3f, d3 = 0.4f;

    int masked_tid = tid & (rate_local_mem_test_size - 1);
    half4 v0 = local_a[masked_tid];
    half4 v1 = local_a[masked_tid + 1];
    half4 v2 = local_a[masked_tid + 2];
    half4 v3 = local_a[masked_tid + 3];
    half4 v4 = v0 + v1;
    half4 v5 = v0 + v2;
    half4 v6 = v0 + v3;
    half4 v7 = v1 + v2;
    half4 acc = local_a[0];

    for (int i = 0; i < count; i++) {
        d0 += dot(acc, v0);
        d1 += dot(acc, v1);
        d2 += dot(acc, v2);
        d3 += dot(acc, v3);
    }

    ret[get_global_id(0)] = d0 + d1 + d2 + d3;
}
