dd if=/dev/zero of=/dir/zeros.img count=1 bs=1 seek=$((10 * 1024 * 1024 * 1024 - 1))
dd if=/dev/urandom of=/dir/random.img count=1024 bs=10M